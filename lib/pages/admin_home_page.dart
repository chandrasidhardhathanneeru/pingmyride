import 'package:flutter/material.dart';
import 'admin_buses_page.dart';
import 'admin_drivers_page.dart';
import 'admin_routes_page.dart';
import 'admin_live_monitor_page.dart';
import 'admin_bookings_page.dart';
import 'admin_profile_page.dart';

class AdminHomePage extends StatelessWidget {
  final String adminName;
  const AdminHomePage({super.key, this.adminName = 'Admin'});

  Widget _tile(BuildContext context, String title, String subtitle, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: Colors.black54)),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample/static data for dashboard cards and recent bookings
    final kpis = [
      {'label': 'Active Buses', 'value': '12'},
      {'label': 'On-time %', 'value': '92%'},
      {'label': 'Bookings today', 'value': '284'},
      {'label': 'Drivers Online', 'value': '14'},
    ];

    final recent = [
      '#8F2JK - KARE-101 - ₹25',
      '#8F3LM - KARE-102 - ₹25',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text('Admin - $adminName'),
        backgroundColor: const Color(0xFF0E1112),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminProfilePage(adminName: 'Admin User', adminEmail: 'admin@example.com'))),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // KPI row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: kpis.map((k) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(k['label']!, style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 8),
                          Text(k['value']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Map + Recent bookings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Text('Map Preview', style: TextStyle(color: Colors.black26))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recent Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...recent.map((r) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFFF6F7F9), borderRadius: BorderRadius.circular(8)),
                                child: Text(r),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Options list (Buses, Drivers, Routes & Schedules, Live Monitor, Bookings)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    _tile(context, 'Buses', 'Manage buses', const AdminBusesPage()),
                    _tile(context, 'Drivers', 'Manage drivers & assign', const AdminDriversPage()),
                    _tile(context, 'Routes & Schedules', 'Manage routes and schedules', const AdminRoutesPage()),
                    _tile(context, 'Live Monitor', 'Fleet map and live status', const AdminLiveMonitorPage()),
                    _tile(context, 'Bookings', 'Bookings & history', const AdminBookingsPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
