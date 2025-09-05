import 'package:flutter/material.dart';
import '../services/bus_repository.dart';

class AdminBusesPage extends StatefulWidget {
  const AdminBusesPage({super.key});

  @override
  State<AdminBusesPage> createState() => _AdminBusesPageState();
}

class _AdminBusesPageState extends State<AdminBusesPage> {
  late BusRepository _repo;
  bool _loading = true;

  final _nameC = TextEditingController();
  final _routeC = TextEditingController();

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
    _nameC.dispose();
    _routeC.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _nameC.text.trim();
    final route = _routeC.text.trim();
    if (name.isEmpty || route.isEmpty) return;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
    await _repo.addBus(Bus(id: id, name: name, route: route));
    _nameC.clear();
    _routeC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buses')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _nameC, decoration: const InputDecoration(hintText: 'Bus name'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: _routeC, decoration: const InputDecoration(hintText: 'Route description'))),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: _add, child: const Text('Add')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _repo.buses.length,
                      itemBuilder: (context, i) {
                        final b = _repo.buses[i];
                        return Card(
                          child: ListTile(
                            title: Text(b.name),
                            subtitle: Text(b.route),
                            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _repo.removeBus(b.id)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
