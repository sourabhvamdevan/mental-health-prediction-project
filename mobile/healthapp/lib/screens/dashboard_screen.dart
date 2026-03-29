import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Your Wellness Dashboard"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildLatestResultCard(),
            const SizedBox(height: 20),
            const Text(
              "Weekly Mood Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildLineChart(),
            const SizedBox(height: 20),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, Sourabh!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ),
        const Text(
          "Here is how your mental health looks today.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLatestResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade700]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Latest Ensemble Prediction",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            "Stable / Low Stress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              Text(
                "92% Confidence (RF, XGB, Cat, LGBM)",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 1),
                const FlSpot(2, 4),
                const FlSpot(3, 2),
                const FlSpot(4, 5),
                const FlSpot(5, 3),
                const FlSpot(6, 4),
              ],
              isCurved: true,
              color: Colors.teal,
              barWidth: 4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _actionCard(
          context,
          "Take Test",
          Icons.assignment_outlined,
          Colors.blue,
          '/input',
        ),
        _actionCard(
          context,
          "Daily Mood",
          Icons.emoji_emotions_outlined,
          Colors.orange,
          '/mood',
        ),
        _actionCard(
          context,
          "Talk to AI",
          Icons.chat_bubble_outline,
          Colors.purple,
          '/chat',
        ),
        _actionCard(
          context,
          "Find Help",
          Icons.location_on_outlined,
          Colors.red,
          '/maps',
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
