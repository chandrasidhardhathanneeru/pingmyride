import 'package:flutter/material.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {'id': 'TKT100', 'bus': 'Express 100', 'date': '2025-09-01'},
      {'id': 'TKT101', 'bus': 'Local 200', 'date': '2025-08-28'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final t = tickets[i];
          return Card(
            color: const Color(0xFF0E1112),
            child: ListTile(
              title: Text(t['bus']!, style: const TextStyle(color: Colors.white)),
              subtitle: Text('${t['id']} • ${t['date']}', style: const TextStyle(color: Colors.white70)),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: tickets.length,
      ),
    );
  }
}
