import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support Resources"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildEmergencyCard(),
          const SizedBox(height: 24),
          const Text(
            "Self-Help Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          const Text(
            "Recommended Articles",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildArticleList(),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text(
            "In a Crisis?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "If you're in immediate danger, please reach out to a helpline.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () => _launchURL("tel:988"),
            icon: const Icon(Icons.phone),
            label: const Text("Call Helpline (988)"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {
        'title': 'Meditation',
        'icon': Icons.self_improvement,
        'color': Colors.blue,
      },
      {
        'title': 'Exercise',
        'icon': Icons.directions_run,
        'color': Colors.orange,
      },
      {'title': 'Sleep', 'icon': Icons.bedtime, 'color': Colors.indigo},
      {'title': 'Journaling', 'icon': Icons.edit_note, 'color': Colors.green},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: (categories[index]['color'] as Color).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  categories[index]['icon'] as IconData,
                  color: categories[index]['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticleList() {
    final articles = [
      "Understanding Anxiety in the Workplace",
      "5 Breathing Techniques for Immediate Calm",
      "How Ensemble Models Predict Mental Health",
      "The Link Between Sleep and Stress",
    ];

    return Column(
      children: articles
          .map(
            (title) => ListTile(
              leading: const Icon(Icons.article_outlined, color: Colors.teal),
              title: Text(title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          )
          .toList(),
    );
  }
}
