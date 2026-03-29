import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  int age = 25;
  String gender = 'Male';
  String familyHistory = 'No';
  String workInterfere = 'Never';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Assessment")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("Please answer accurately for the Ensemble Model to analyze."),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => age = int.parse(val),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Family History of Mental Illness?",
              ),
              items: ['Yes', 'No']
                  .map(
                    (label) =>
                        DropdownMenuItem(child: Text(label), value: label),
                  )
                  .toList(),
              onChanged: (val) => familyHistory = val!,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultScreen(age: age, history: familyHistory),
                  ),
                );
              },
              child: Text("Analyze with Ensemble Model"),
            ),
          ],
        ),
      ),
    );
  }
}
