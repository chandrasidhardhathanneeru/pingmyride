import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
     final history = [
      {'action': 'Booked Express 100', 'date': '2025-09-01'},
      {'action': 'Cancelled Local 200', 'date': '2025-08-15'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final h = history[i];
          return Card(
            color: const Color(0xFF0E1112),
            child: ListTile(
              title: Text(h['action']!, style: const TextStyle(color: Colors.white)),
              subtitle: Text(h['date']!, style: const TextStyle(color: Colors.white70)),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: history.length,
      ),
    );
  }
}
