import 'package:flutter/material.dart';

import 'book_bus_page.dart';
import 'live_track_page.dart';
import 'tickets_page.dart';
import 'alerts_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class UserHomePage extends StatefulWidget {
  final String userName;
  const UserHomePage({super.key, required this.userName});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // Sample data to demonstrate live search
  final List<Map<String, String>> _buses = [
    {'id': 'BUS100', 'route': 'A → B', 'name': 'Express 100'},
    {'id': 'BUS200', 'route': 'B → C', 'name': 'Local 200'},
    {'id': 'BUS300', 'route': 'C → D', 'name': 'Rapid 300'},
    {'id': 'BUS400', 'route': 'A → D', 'name': 'Intercity 400'},
    {'id': 'BUS500', 'route': 'D → E', 'name': 'Night 500'},
  ];

  List<Map<String, String>> get _filteredBuses {
    if (_query.isEmpty) return _buses;
    final q = _query.toLowerCase();
    return _buses.where((b) => b.values.any((v) => v.toLowerCase().contains(q))).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1112),
        title: Text('Welcome, ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage(userName: widget.userName))),
          )
        ],
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
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Search by route or bus ID', hintStyle: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _query = '';
                        }),
                      )
                  ],
                ),
              ),

              // live suggestions
              if (_query.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  constraints: const BoxConstraints(maxHeight: 160),
                  decoration: BoxDecoration(color: const Color(0xFF0E1112), borderRadius: BorderRadius.circular(8)),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final bus = _filteredBuses[index];
                      return ListTile(
                        title: Text(bus['name']!, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('${bus['id']} • ${bus['route']}', style: const TextStyle(color: Colors.white70)),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookBusPage(bus: bus))),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                    itemCount: _filteredBuses.length,
                  ),
                ),

              const SizedBox(height: 12),

              // Two-row layout: Row 1 has 3 actions, Row 2 has 2 actions centered
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: ActionCard(icon: Icons.event_seat, label: 'Book Bus', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookBusPage())))),
                        const SizedBox(width: 12),
                        Expanded(child: ActionCard(icon: Icons.location_on, label: 'Live Track', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LiveTrackPage())))),
                        const SizedBox(width: 12),
                        Expanded(child: ActionCard(icon: Icons.confirmation_number, label: 'My Tickets', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TicketsPage())))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(flex: 1, child: SizedBox(width: 160, child: ActionCard(icon: Icons.notifications, label: 'Alerts', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlertsPage()))))),
                        const SizedBox(width: 12),
                        Flexible(flex: 1, child: SizedBox(width: 160, child: ActionCard(icon: Icons.history, label: 'History', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryPage()))))),
                      ],
                    ),
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

class ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionCard({super.key, required this.icon, required this.label, required this.onTap});

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..translate(0.0, _pressed ? 2.0 : 0.0),
      child: Material(
        color: const Color(0xFF0E1112),
        borderRadius: BorderRadius.circular(12),
        elevation: _pressed ? 8 : 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.green[400], size: 28),
                const SizedBox(height: 8),
                Text(widget.label, style: const TextStyle(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
