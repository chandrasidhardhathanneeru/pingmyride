import 'package:flutter/material.dart';
// using timestamp-based ids instead of uuid package
import '../services/driver_repository.dart';
import '../services/bus_repository.dart';

class AdminDriversPage extends StatefulWidget {
  const AdminDriversPage({super.key});

  @override
  State<AdminDriversPage> createState() => _AdminDriversPageState();
}

class _AdminDriversPageState extends State<AdminDriversPage> {
  late DriverRepository _drepo;
  late BusRepository _brepo;
  bool _loading = true;

  final _nameC = TextEditingController();
  final _dlC = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.wait([DriverRepository.getInstance(), BusRepository.getInstance()]).then((r) {
      _drepo = r[0] as DriverRepository;
      _brepo = r[1] as BusRepository;
      _drepo.addListener(_onRepo);
      _brepo.addListener(_onRepo);
      setState(() => _loading = false);
    });
  }

  void _onRepo() => setState(() {});

  @override
  void dispose() {
    _drepo.removeListener(_onRepo);
    _brepo.removeListener(_onRepo);
    _nameC.dispose();
    _dlC.dispose();
    super.dispose();
  }

  Future<void> _addDriver() async {
    final name = _nameC.text.trim();
    final dl = _dlC.text.trim();
    if (name.isEmpty || dl.isEmpty) return;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _drepo.addDriver(Driver(id: id, name: name, licence: dl));
    _nameC.clear();
    _dlC.clear();
  }

  Future<void> _assign(String driverId, String busId) async {
    await _brepo.assignDriver(busId, driverId);
  }

  Future<void> _unassign(String busId) async {
    await _brepo.assignDriver(busId, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drivers & Assignments')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _nameC, decoration: const InputDecoration(hintText: 'Driver name'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _dlC, decoration: const InputDecoration(hintText: 'DL number'))),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: _addDriver, child: const Text('Add')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text('Drivers', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ..._drepo.drivers.map((d) => Card(
                              child: ListTile(
                                title: Text(d.name),
                                subtitle: Text('DL: ${d.licence}'),
                                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _drepo.removeDriver(d.id)),
                              ),
                            )),
                        const SizedBox(height: 12),
                        const Text('Buses & Assignments', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ..._brepo.buses.map((b) {
                          final assigned = b.assignedDriverId == null ? null : _drepo.drivers.firstWhere((dd) => dd.id == b.assignedDriverId, orElse: () => Driver(id: '', name: 'Unknown', licence: ''));
                          return Card(
                            child: ListTile(
                              title: Text(b.name),
                              subtitle: Text(b.route),
                              trailing: PopupMenuButton<String>(
                                onSelected: (val) async {
                                  if (val == '__unassign') {
                                    await _unassign(b.id);
                                  } else {
                                    await _assign(val, b.id);
                                  }
                                },
                                itemBuilder: (ctx) {
                                  final items = <PopupMenuEntry<String>>[];
                                  items.add(const PopupMenuItem(value: '__unassign', child: Text('Unassign')));
                                  for (final d in _drepo.drivers) {
                                    items.add(PopupMenuItem(value: d.id, child: Text('Assign ${d.name}')));
                                  }
                                  return items;
                                },
                                child: Text(assigned == null ? 'Assign' : 'Driver: ${assigned.name}'),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
