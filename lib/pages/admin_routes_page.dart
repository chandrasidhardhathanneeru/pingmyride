import 'package:flutter/material.dart';
import '../services/bus_repository.dart';

class AdminRoutesPage extends StatefulWidget {
  const AdminRoutesPage({super.key});

  @override
  State<AdminRoutesPage> createState() => _AdminRoutesPageState();
}

class _AdminRoutesPageState extends State<AdminRoutesPage> {
  late BusRepository _repo;
  bool _loading = true;
  final Map<String, TextEditingController> _controllers = {};

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
    for (final c in _controllers.values) {
      c.dispose();
    }
    _repo.removeListener(_onRepo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routes & Schedules')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _repo.buses.length,
              itemBuilder: (context, idx) {
                final b = _repo.buses[idx];
                final ctrl = _controllers.putIfAbsent(b.id, () => TextEditingController());
                return Card(
                  color: const Color(0xFF0E1112),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(b.route, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: b.schedule
                              .map((t) => Chip(
                                    label: Text(t, style: const TextStyle(color: Colors.black)),
                                    backgroundColor: Colors.amberAccent,
                                    onDeleted: () => _repo.removeSchedule(b.id, t),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrl,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'HH:MM (e.g. 09:30)',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Color(0xFF141617),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                final val = ctrl.text.trim();
                                if (val.isNotEmpty) {
                                  _repo.addSchedule(b.id, val);
                                  ctrl.clear();
                                }
                              },
                              child: const Text('Add'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
