
#  Backend Engineering & Integration Guide

This document provides the technical blueprint for the **Mental Health Prediction** backend, focusing on the synergy between the **Node.js/Express** API gateway and the **Python Ensemble Machine Learning** engine.

---

## 1. System Architecture Overview

The backend operates on a decoupled microservices architecture to ensure scalability and high-performance model inference.



* **API Gateway (Node.js):** Manages user authentication (JWT), database operations (MongoDB), and serves as the primary entry point for Flutter and React clients.
* **Intelligence Engine (Python):** Serves the pre-trained ensemble models (Random Forest, XGBoost, CatBoost, LightGBM) via a lightweight REST bridge (Flask or FastAPI).
* **Data Persistence (MongoDB Atlas):** Stores encrypted user profiles, longitudinal mood logs, and historical prediction results.

---

## 2. The Ensemble Intelligence Model

To minimize false positives and handle the complexity of mental health datasets, the system utilizes a **Weighted Voting Ensemble** approach.



### Model Components:
1.  **Random Forest (Bagging):** Reduces variance by averaging multiple deep decision trees. It provides a stable baseline that is less sensitive to outliers.
2.  **XGBoost (Boosting):** An optimized gradient boosting framework designed for high speed and categorical accuracy.
3.  **CatBoost (Boosting):** Specifically tuned to handle categorical features (e.g., gender, family history, work interference) without manual one-hot encoding.
4.  **LightGBM (Boosting):** Uses leaf-wise growth to provide high accuracy with faster inference times, critical for real-time mobile responses.

---

## 3. Core API Endpoints

All endpoints are prefixed with `/api` and require a JSON body for POST requests.

| Method | Endpoint | Description | Payload Example |
| :--- | :--- | :--- | :--- |
| **POST** | `/auth/signup` | Register a new user profile in MongoDB. | `{"userName": "Sourabh", "email": "..."}` |
| **POST** | `/auth/login` | Authenticate and return a secure JWT token. | `{"email": "...", "password": "..."}` |
| **POST** | `/predict` | Send survey features to the Ensemble Model. | `{"age": 22, "family_history": "Yes"}` |
| **GET** | `/history` | Retrieve historical prediction trends for the user. | *Header: Authorization: Bearer <Token>* |

---

## 4. Integration Logic: Node.js to ML Service

The Node.js backend acts as an orchestrator. When a `/predict` request arrives from the Flutter app:

1.  **Extraction:** Node.js extracts the survey features (Age, Gender, History, etc.) from the request.
2.  **Validation:** Input is sanitized to ensure no null values are passed to the ML models.
3.  **Inference Call:** Node.js makes an internal HTTP POST request to the Python ML microservice.
4.  **Ensemble Aggregation:** The Python service runs the data through the four models, calculates the **Weighted Average**, and returns the final prediction class and a confidence score (%).
5.  **Response:** Node.js logs the result in MongoDB and returns the final JSON to the Flutter client.

---

## 5. Security & Environment Setup

### Environment Variables (.env)
Create a `.env` file in the `server/` directory. **Do not commit this file to GitHub.**

```env
PORT=8000
MONGO_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/mental_health
JWT_SECRET=your_super_secret_key_here
ML_SERVICE_URL=http://localhost:5000/predict
