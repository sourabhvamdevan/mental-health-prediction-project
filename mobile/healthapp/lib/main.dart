import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();
  String _stressLevel = 'Low';
  String _sleepQuality = 'Good';
  bool _isLoading = false;
  String _result = "";

  Future<void> getPrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Replace with your Laptop's IP if using a real phone, or 10.0.2.2 for Android Emulator
    const String apiUrl = "http://localhost:8000/api/predict";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "age": int.parse(_ageController.text),
          "stress_level": _stressLevel,
          "sleep_quality": _sleepQuality,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _result = "Prediction: ${data['prediction']}");
      } else {
        setState(
          () => _result = "Error: Server returned ${response.statusCode}",
        );
      }
    } catch (e) {
      setState(
        () => _result = "Connection failed. Check if server is running.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mental Health Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Enter details for Ensemble Model analysis:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter age" : null,
              ),

              const SizedBox(height: 15),
              DropdownButtonFormField(
                value: _stressLevel,
                decoration: const InputDecoration(
                  labelText: "Stress Level",
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _stressLevel = value!),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : getPrediction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Predict Status"),
              ),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
