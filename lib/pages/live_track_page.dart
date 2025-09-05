import 'package:flutter/material.dart';

class LiveTrackPage extends StatelessWidget {
  const LiveTrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Track')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live tracking (simulated)', style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 8),
            Card(
              color: const Color(0xFF0E1112),
              child: ListTile(
                leading: const Icon(Icons.directions_bus, color: Colors.green),
                title: const Text('Express 100', style: TextStyle(color: Colors.white)),
                subtitle: const Text('ETA: 5 mins • Speed: 45 km/h', style: TextStyle(color: Colors.white70)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Map view would appear here in a full implementation.', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
