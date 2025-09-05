import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'text': 'Delay on route A → B', 'time': '2h ago'},
      {'text': 'Service change for Local 200', 'time': '1d ago'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final a = alerts[i];
          return Card(
            color: const Color(0xFF0E1112),
            child: ListTile(
              leading: const Icon(Icons.notification_important, color: Colors.orange),
              title: Text(a['text']!, style: const TextStyle(color: Colors.white)),
              subtitle: Text(a['time']!, style: const TextStyle(color: Colors.white70)),
            ),
          );
        },
        itemCount: alerts.length,
      ),
    );
  }
}
