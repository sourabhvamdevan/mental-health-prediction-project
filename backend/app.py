from flask import Flask, request, jsonify
import joblib
import numpy as np
import os
import logging
from flask_cors import CORS
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from dotenv import load_dotenv
import pickle

load_dotenv()
# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": ["https://mindguardai.vercel.app", "http://localhost:5173"]}}, supports_credentials=True)  # Enable CORS for React frontend

# # Load trained model & scaler
MODEL_PATH = ("./mental_random_forest.pkl")
SCALER_PATH = ("./scaler.pkl")
try:
    if not os.path.exists(MODEL_PATH) or not os.path.exists(SCALER_PATH):
        raise FileNotFoundError("Model or Scaler file not found. Check paths!")

    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    logger.info("✅ Model and scaler loaded successfully")
except Exception as e:
    logger.error(f"❌ Error loading model or scaler: {e}")
    raise

# Email Credentials (Use an App Password for Gmail)
EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")  # Use an App Password

# Mental Health Descriptions & Recommendations
mental_health_descriptions = {
    0: {
        "category": "Very Healthy 🟢",
        "description": "Individuals in this category exhibit excellent mental well-being. "
                       "They maintain a balanced lifestyle, manage stress effectively, and show no significant signs of emotional distress. "
                       "They have good sleep patterns, stable moods, and positive social interactions.",
        "recommendations": [
            "Maintain a balanced diet and regular exercise.",
            "Engage in mindfulness and relaxation activities.",
            "Continue positive social interactions and healthy sleep patterns."
        ]
    },
    1: {
        "category": "Mild Issues 🟡",
        "description": "People in this category may experience occasional stress, mood swings, or mild anxiety, "
                       "but these do not significantly impact daily life. They might have slightly irregular sleep patterns, "
                       "reduced energy levels, or minor social withdrawal. However, with self-care and mindfulness, they can maintain a good mental state.",
        "recommendations": [
            "Engage in stress-relief activities like meditation and yoga.",
            "Talk to loved ones or a mentor about stressors.",
            "Ensure proper sleep and nutrition to maintain energy levels."
        ]
    },
    2: {
        "category": "Moderate Concerns 🟠",
        "description": "This group experiences noticeable mental health challenges, such as persistent stress, anxiety, or mood instability. "
                       "Symptoms may include sleep disturbances, fatigue, difficulty concentrating, and increased social withdrawal. "
                       "Intervention through lifestyle changes, counseling, or mild therapy is recommended.",
        "recommendations": [
            "Consider therapy or counseling for emotional support.",
            "Adopt structured routines to manage stress and anxiety.",
            "Practice regular self-care, including exercise and hobbies."
        ]
    },
    3: {
        "category": "High Risk 🔴",
        "description": "Individuals in this category show strong signs of mental distress, such as chronic anxiety, depression, or emotional instability. "
                       "They may experience severe sleep disturbances, lack of motivation, high stress, or even signs of burnout. "
                       "Professional help, therapy, or medical support is highly recommended to prevent further deterioration.",
        "recommendations": [
            "Seek professional mental health support immediately.",
            "Avoid social isolation—talk to trusted friends or family.",
            "Adopt relaxation techniques and engage in structured therapy."
        ]
    }
}

# Function to Send Email via Gmail SMTP
def send_email(to_email, subject, body):
    msg = MIMEMultipart()
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(EMAIL_ADDRESS, to_email, msg.as_string())
        server.quit()
        logger.info(f"✅ Email sent successfully to {to_email}")
    except smtplib.SMTPAuthenticationError:
        logger.error("❌ Email Authentication Error: Check Gmail credentials or enable App Passwords.")
    except Exception as e:
        logger.error(f"❌ Email Error: {e}")

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "model_loaded": True})

@app.route('/predict', methods=['POST'])
def predict():
    """
    Predict mental health condition based on input features.
    Expected input format: {"features": [f1, f2, ..., fn], "email": "user@example.com"}
    """
    try:
        # Get JSON data from request
        data = request.json
        if not data or "features" not in data:
            return jsonify({"error": "Missing 'features' in request"}), 400

        features = data["features"]
        email = data.get("email")

        # Validate features is a list
        if not isinstance(features, list):
            return jsonify({"error": "Features must be a list"}), 400

        # Convert input to NumPy array
        features = np.array(features).reshape(1, -1)

        # Validate feature count
        expected_features = model.n_features_in_
        if features.shape[1] != expected_features:
            return jsonify({"error": f"Expected {expected_features} features, got {features.shape[1]}"}), 400

        # Scale features
        try:
            features_scaled = scaler.transform(features)
        except Exception as e:
            logger.error(f"❌ Error during feature scaling: {e}")
            return jsonify({"error": "Error scaling features. Check feature values."}), 400

        # Predict mental health condition
        prediction = model.predict(features_scaled)[0]
        mental_health_info = mental_health_descriptions.get(int(prediction), {})

        # Prepare message
        message = f"Your Mental Health Prediction:\n\nCategory: {mental_health_info['category']}\n\n" \
                  f"Description: {mental_health_info['description']}\n\n" \
                  f"Recommendations:\n- " + "\n- ".join(mental_health_info["recommendations"])

        # Send Email (if provided)
        if email:
            send_email(email, "Mental Health Prediction", message)

        # Log successful prediction
        logger.info(f"✅ Successful prediction: {prediction}")

        # Return prediction result
        return jsonify({
            "mental_health_condition": int(prediction),
            "category": mental_health_info["category"],
            "description": mental_health_info["description"],
            "recommendations": mental_health_info["recommendations"],
            "status": "success"
        })

    except ValueError as ve:
        logger.error(f"❌ ValueError in prediction: {ve}")
        return jsonify({"error": "Invalid feature values provided"}), 400
    except Exception as e:
        logger.error(f"❌ Unexpected error in prediction: {e}")
        return jsonify({"error": "An unexpected error occurred"}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug_mode = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    app.run(host='0.0.0.0', port=port, debug=debug_mode)
