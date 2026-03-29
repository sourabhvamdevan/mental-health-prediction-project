import 'dart:convert';
import 'dart:io';

import 'package:langchain_google/langchain_google.dart';

class LangChainService {
  final String apiKey = "api_key";

  Future<String> getCounselorResponse(
    String userMessage,
    Map<String, dynamic> predictionData,
  ) async {
    final llm = ChatGoogleGenerativeAI(apiKey: apiKey);

    // Context from your Random Forest/XGBoost ensemble
    final context =
        "The user's current mental health prediction is ${predictionData['result']} "
        "with a confidence of ${predictionData['confidence']}%. "
        "Individual model scores: RF: ${predictionData['rf']}, XGB: ${predictionData['xgb']}.";

    final prompt = PromptTemplate.fromTemplate('''
      You are a supportive Mental Health Assistant. 
      Context: {context}
      User says: {message}
      
      Provide a compassionate response. If the prediction is 'High Stress', 
      suggest breathing exercises. Do not give medical prescriptions.
    ''');

    final chain = prompt | llm | StringOutputParser();

    final response = await chain.invoke({
      "context": context,
      "message": userMessage,
    });

    return response;
  }
}
