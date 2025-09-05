import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'scan_page.dart';

class DriverHomePage extends StatefulWidget {
  final String driverName;
  const DriverHomePage({super.key, this.driverName = 'Driver'});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  Widget _homeView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Status: Online', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Sharing location every 5s', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              TextButton(onPressed: () => _changeBus(), child: const Text('Change Bus', style: TextStyle(color: Colors.white70))),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            color: const Color(0xFF0E1112),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('TODAY', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 8),
                  Text('Route: Downtown → Campus • 10 stops • First trip', style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('09:30 AM', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: () => _startScanning(),
            child: const Text('Start Scanning Tickets', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _scanView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.qr_code_scanner, size: 80, color: Colors.white70),
          SizedBox(height: 12),
          Text('Scan mode (placeholder)', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _tripView() {
    final stops = [
      {'name': 'City Center', 'eta': 'ETA 2 min', 'waiting': '3 waiting'},
      {'name': 'Tech Park', 'eta': 'ETA 8 min', 'waiting': '1 waiting'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // Top header bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0E1112),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Trip Dashboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('KARE-101', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Stops list
          Expanded(
            child: ListView.separated(
              itemCount: stops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = stops[i];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121416),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name']!, style: const TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(s['eta']!, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B0F12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(s['waiting']!, style: const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          // End Shift button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // TODO: end shift action
              },
              child: const Text('End Shift', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileView() {
  return ProfilePage(userName: widget.driverName, isDriver: true);
  }

  void _startScanning() {
  // Navigate to the visual ScanPage (camera placeholder). In a real app this
  // would request camera permissions and use a scanning plugin.
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ScanPage()));
  }

  void _changeBus() {
    showModalBottomSheet(context: context, builder: (ctx) {
      return Container(
        color: const Color(0xFF0B0F12),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const ListTile(title: Text('Select Bus', style: TextStyle(color: Colors.white))),
            const Divider(color: Colors.white10),
            ListTile(title: const Text('Bus 100 - Downtown → Campus', style: TextStyle(color: Colors.white70)), onTap: () => Navigator.of(ctx).pop()),
            ListTile(title: const Text('Bus 200 - Campus → Downtown', style: TextStyle(color: Colors.white70)), onTap: () => Navigator.of(ctx).pop()),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final views = [_homeView(), _scanView(), _tripView(), _profileView()];
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(child: views[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        backgroundColor: const Color(0xFF0E1112),
        selectedItemColor: Colors.green[400],
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Trip'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
