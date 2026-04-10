import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MindCareApp());
}

class MindCareApp extends StatelessWidget {
  const MindCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MindCare",
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/input': (context) => const InputScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.white],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 100, color: Colors.teal),
            Text(
              "MindCare",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AI-Powered Mental Health Insights using Ensemble Modeling",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/input'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Start Assessment"),
            ),
          ],
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();

  String stressLevel = 'Low';
  String sleepQuality = 'Good';
  bool isLoading = false;
  String result = "";

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  Future<void> getPrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    const url = "http://10.0.2.2:8000/api/predict";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "age": int.parse(ageController.text),
          "stress_level": stressLevel,
          "sleep_quality": sleepQuality,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => result = "Prediction: ${data['prediction']}");
      } else {
        setState(() => result = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => result = "Server connection failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assessment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter age" : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField(
                value: stressLevel,
                decoration: const InputDecoration(
                  labelText: "Stress Level",
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => stressLevel = v!),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                value: sleepQuality,
                decoration: const InputDecoration(
                  labelText: "Sleep Quality",
                  border: OutlineInputBorder(),
                ),
                items: ['Good', 'Average', 'Poor']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => sleepQuality = v!),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : getPrediction,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Predict"),
              ),

              const SizedBox(height: 20),

              Center(child: Text(result, style: const TextStyle(fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}
