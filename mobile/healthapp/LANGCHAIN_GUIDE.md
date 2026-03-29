
#  LangChain & Generative AI Integration Guide

This guide explains how the Flutter application utilizes **LangChain** to provide context-aware mental health support by bridging the gap between **Predictive AI** (Ensemble Models) and **Generative AI** (LLMs).

---

## 1. The "Context-Aware" Architecture

Unlike standard chatbots, this implementation uses a **RAG-lite (Retrieval-Augmented Generation)** approach. The AI doesn't just chat; it "sees" the user's latest health data before responding.



### Data Flow:
1.  **Input:** User runs the ensemble model test (XGBoost, CatBoost, etc.).
2.  **Context Injection:** The `LangChainService` extracts the result (e.g., "High Stress") and individual model confidence scores.
3.  **Prompt Engineering:** These scores are injected into a system prompt template.
4.  **Inference:** The LLM (Gemini/GPT) generates a response that is specifically tailored to that user's unique prediction profile.

---

## 2. Core Components

### A. LangChain Service (`langchain_service.dart`)
This is the "Brain" of the integration. It handles:
* **Prompt Templates:** Standardizing how the AI behaves (Supportive Counselor persona).
* **LLM Chains:** Creating a sequence where the input is piped through the model and parsed into a clean string.
* **Output Parsing:** Ensuring the AI response is formatted correctly for the Flutter UI.

### B. AI Chat Screen (`ai_chat_screen.dart`)
The user interface that handles:
* **State Management:** Tracking the conversation history.
* **Context Passing:** Ensuring the `ensembleContext` Map is passed from the Result Screen to the Chat.

---

## 3. Advanced Features

### Explainable AI (XAI)
The primary role of LangChain in this project is to act as an **Interpreter**. 
* **Example:** If **Random Forest** predicts "Stable" but **XGBoost** predicts "High Stress," the LangChain agent can explain: *"While most of our models see stability, one detected patterns consistent with work-related interference. Let's focus on that."*

### Personalized Wellness Planning
Based on the prediction class, the LangChain agent is instructed to suggest specific resources from the `ResourcesScreen`, such as:
* **Low Stress:** Preventive mindfulness and habit tracking.
* **High Stress:** Immediate breathing exercises and crisis helpline information.

---

## 4. Security & Safety Guardrails

Because this app handles sensitive mental health data, the LangChain prompt includes **Strict Safety Instructions**:
1.  **No Medical Diagnosis:** The AI is forbidden from prescribing medication or giving formal medical diagnoses.
2.  **Crisis Detection:** If keywords like "harm" or "emergency" are detected, the AI is programmed to immediately output a standardized "Seek Professional Help" message.
3.  **Privacy:** No personally identifiable information (PII) like names or addresses should be sent to the LLM API.

---

## 5. Configuration

### API Keys
Ensure your API Key is stored securely in your `.env` file and accessed via `flutter_dotenv`:
```env
GEMINI_API_KEY=your_key_here