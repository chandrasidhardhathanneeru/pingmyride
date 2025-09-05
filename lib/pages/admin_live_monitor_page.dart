import 'package:flutter/material.dart';
import '../services/bus_repository.dart';

class AdminLiveMonitorPage extends StatefulWidget {
  const AdminLiveMonitorPage({super.key});

  @override
  State<AdminLiveMonitorPage> createState() => _AdminLiveMonitorPageState();
}

class _AdminLiveMonitorPageState extends State<AdminLiveMonitorPage> {
  late BusRepository _repo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    BusRepository.getInstance().then((r) {
      _repo = r;
      _repo.addListener(_onRepo);
      setState(() => _loading = false);
    });
  }

  void _onRepo() => setState(() {});

  @override
  void dispose() {
    _repo.removeListener(_onRepo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buses = _loading ? [] : _repo.buses;
    return Scaffold(
      appBar: AppBar(title: const Text('Live Monitor')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth ~/ 320).clamp(1, 4);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: buses.length,
                  itemBuilder: (context, idx) {
                    final b = buses[idx];
                    final isOnline = b.assignedDriverId != null;
                    // Mock ETA text — replace with real telemetry when available
                    final eta = 'ETA to next stop: ${4 + (idx % 6)} min';
                    return Card(
                      color: const Color(0xFFF7F7F7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: isOnline ? Colors.green[100] : Colors.grey[300], borderRadius: BorderRadius.circular(16)),
                                  child: Text(isOnline ? 'Online' : 'Offline', style: TextStyle(color: isOnline ? Colors.green[800] : Colors.black54, fontSize: 12)),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.map_outlined, size: 36, color: Colors.black26),
                                      SizedBox(height: 8),
                                      Text('Map', style: TextStyle(color: Colors.black26)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(eta, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
    );
  }
}
