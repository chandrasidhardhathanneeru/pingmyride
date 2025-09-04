import 'package:flutter/material.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: const Center(child: Text('My Tickets - placeholder')),
    );
  }
}
