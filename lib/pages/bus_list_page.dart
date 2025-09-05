import 'package:flutter/material.dart';
import '../services/bus_repository.dart';
import '../services/driver_repository.dart';
import 'confirm_booking_page.dart';

class BusListPage extends StatefulWidget {
  final String from;
  final String to;
  final DateTime date;
  final TimeOfDay time;
  const BusListPage({super.key, required this.from, required this.to, required this.date, required this.time});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late BusRepository _repo;
  bool _loading = true;
  bool _driversLoaded = false;
  DriverRepository? _driverRepo;

  @override
  void initState() {
    super.initState();
    BusRepository.getInstance().then((r) {
      _repo = r;
      _repo.addListener(_onRepo);
      // also try to load drivers (optional)
      DriverRepository.getInstance().then((dr) {
        _driverRepo = dr;
        _driverRepo!.addListener(_onRepo);
        setState(() {
          _driversLoaded = true;
          _loading = false;
        });
      }).catchError((_) {
        setState(() => _loading = false);
      });
    });
  }

  void _onRepo() => setState(() {});

  @override
  void dispose() {
    _repo.removeListener(_onRepo);
  _driverRepo?.removeListener(_onRepo);
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Buses')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _repo.buses.isEmpty
              ? const Center(child: Text('No buses available. Admin can add buses.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _repo.buses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final m = _repo.buses[idx];
                                    String driverName;
                                    if (m.assignedDriverId != null && _driverRepo != null) {
                                      final found = _driverRepo!.drivers.where((d) => d.id == m.assignedDriverId).toList();
                                      driverName = found.isNotEmpty ? found.first.name : 'Unassigned';
                                    } else {
                                      driverName = m.assignedDriverId != null ? 'Assigned' : 'Unassigned';
                                    }
                    return Card(
                      color: const Color(0xFF0E1112),
                      child: ListTile(
                        title: Text(m.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.route, style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('Driver: $driverName', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConfirmBookingPage(busName: m.name, busId: m.id, fare: '₹99')));
                          },
                          child: const Text('Book'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
