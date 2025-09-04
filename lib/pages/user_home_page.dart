import 'package:flutter/material.dart';

import 'book_bus_page.dart';
import 'live_track_page.dart';
import 'tickets_page.dart';
import 'alerts_page.dart';
import 'history_page.dart';

class UserHomePage extends StatelessWidget {
  final String userName;
  const UserHomePage({super.key, required this.userName});

  Widget _buildAction(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)),
      child: Card(
        color: const Color(0xFF0E1112),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green[400], size: 28),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1112),
        title: Text('Welcome, $userName'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFF141617), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Search by route or bus ID', hintStyle: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Grid buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildAction(context, Icons.event_seat, 'Book Bus', const BookBusPage()),
                    _buildAction(context, Icons.location_on, 'Live Track', const LiveTrackPage()),
                    _buildAction(context, Icons.confirmation_number, 'My Tickets', const TicketsPage()),
                    _buildAction(context, Icons.notifications, 'Alerts', const AlertsPage()),
                    _buildAction(context, Icons.history, 'History', const HistoryPage()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
