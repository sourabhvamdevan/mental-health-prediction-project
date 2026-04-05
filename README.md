

# Mental Health Prediction System 
![License](https://img.shields.io/badge/License-MIT-yellow)
![Node.js](https://img.shields.io/badge/Node.js-16+-green?logo=node.js&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter&logoColor=white)
![React](https://img.shields.io/badge/React-Web-61DAFB?logo=react&logoColor=black)
![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-green?logo=mongodb&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.8+-blue?logo=python&logoColor=white)
![ML](https://img.shields.io/badge/ML-Ensemble%20Learning-orange)
![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker&logoColor=white)
![JWT](https://img.shields.io/badge/Auth-JWT-black)
![LangChain](https://img.shields.io/badge/GenAI-LangChain-purple)

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter&logoColor=white)](https://flutter.dev/)
[![React](https://img.shields.io/badge/React-Web-61DAFB?logo=react&logoColor=black)](https://react.dev/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-green?logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Python](https://img.shields.io/badge/Python-3.8+-blue?logo=python&logoColor=white)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

This project is a full-stack health-tech application designed to predict mental health conditions using an **Ensemble Learning** approach. It leverages a modern tech stack consisting of a **Flutter** mobile app, a **React** web dashboard, and a **Node.js** backend, with a high-performance machine learning core.

## Features
- **Cross-Platform:** Access the system via Mobile (Flutter) or Web (React).
- **Advanced ML Core:** Uses an ensemble of **XGBoost, CatBoost, and LightGBM** for robust and accurate predictions.
- **Secure Authentication:** JWT-based user authentication with encrypted password storage.
- **Real-time Analytics:** Interactive dashboard to visualize mental health trends and predictions.
- **Cloud-Integrated:** Powered by **MongoDB Atlas** for scalable and secure data management.

## Tech Stack
| Category | Technology |
| :--- | :--- |
| **Mobile** | Flutter (Dart) (GetX) |
| **Web** | React.js, Tailwind CSS |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB Atlas |
| **Machine Learning** | XGBoost, CatBoost, LightGBM, RandomForest |
| **DevOps** | Docker, Git |
| **Generative AI** | LangChain, Langraph |

## Architecture
The system follows a micro-service inspired architecture where the frontend clients communicate with a central Node.js API, which in turn interfaces with a Python-based ML service.



## Prerequisites
- Node.js (v16+)
- Flutter SDK
- Python 3.8+ (for ML models)
- MongoDB Atlas Account

## Installation & Setup

### Backend (Node.js/Express)
```bash
cd server
npm install
# Create a .env file and add:
# MONGO_URI=your_mongodb_atlas_uri
# PORT=8000
npm start
```

### Frontend (React)
```bash
cd client
npm install
npm start
```

###  Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

###  Machine Learning Service
Ensure you have the required Python packages installed to serve the ensemble models:
```bash
pip install xgboost catboost lightgbm flask scikit-learn
python app.py
```

##  Ensemble Model Logic
The prediction engine utilizes a **Weighted Voting Ensemble**:
- **XGBoost:** High-speed gradient boosting for structured data.
- **CatBoost:** Superior handling of categorical features without manual encoding.
- **LightGBM:** Memory-efficient boosting for fast mobile-side responses.
- **RandomForest:** Reduces variance by averaging multiple deep decision trees. It provides a "stable baseline" for the ensemble.



##  License
Distributed under the MIT License. See `LICENSE` for more information.

---
**Disclaimer:** *This tool is for educational and informational purposes only and does not substitute professional medical advice, diagnosis, or treatment.*
