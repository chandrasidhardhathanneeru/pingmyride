import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  final String id;
  final String name;
  final String route;
  String? assignedDriverId;
  List<String> schedule;

  Bus({required this.id, required this.name, required this.route, this.assignedDriverId, List<String>? schedule}) : schedule = schedule ?? [];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'route': route, 'assignedDriverId': assignedDriverId, 'schedule': schedule};
  static Bus fromJson(Map<String, dynamic> j) => Bus(
      id: j['id'] as String,
      name: j['name'] as String,
      route: j['route'] as String,
      assignedDriverId: j['assignedDriverId'] as String?,
      schedule: (j['schedule'] as List<dynamic>?)?.map((e) => e as String).toList());
}

class BusRepository extends ChangeNotifier {
  static BusRepository? _instance;
  static BusRepository? instanceOrNull() => _instance;
  final List<Bus> _buses = [];

  BusRepository._();

  static Future<BusRepository> getInstance() async {
    if (_instance != null) return _instance!;
    final r = BusRepository._();
    // Try to load from Firestore first; if it fails fall back to local JSON
    try {
      await r._loadFromFirestore();
    } catch (_) {
      await r._load();
    }
    _instance = r;
    return r;
  }

  List<Bus> get buses => List.unmodifiable(_buses);

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/buses.json');
  }

  Future<void> _load() async {
    try {
      final f = await _file();
      if (await f.exists()) {
        final s = await f.readAsString();
        final data = json.decode(s) as List<dynamic>;
        _buses.clear();
        for (final item in data) {
          _buses.add(Bus.fromJson(item as Map<String, dynamic>));
        }
      }
    } catch (e) {
      if (kDebugMode) print('Failed to load buses: $e');
    }
    notifyListeners();
  }

  Future<void> _loadFromFirestore() async {
    final col = FirebaseFirestore.instance.collection('buses');
    final snapshot = await col.get();
    _buses.clear();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      _buses.add(Bus(id: doc.id, name: data['name'] as String? ?? '', route: data['route'] as String? ?? '', assignedDriverId: data['assignedDriverId'] as String?));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final f = await _file();
    final data = _buses.map((b) => b.toJson()).toList();
    await f.writeAsString(json.encode(data));
  }

  Future<void> addBus(Bus b) async {
    _buses.add(b);
    // try Firestore write
    try {
      final col = FirebaseFirestore.instance.collection('buses');
  await col.doc(b.id).set({'name': b.name, 'route': b.route, 'assignedDriverId': b.assignedDriverId, 'schedule': b.schedule});
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }

  Future<void> removeBus(String id) async {
    _buses.removeWhere((b) => b.id == id);
    try {
      final col = FirebaseFirestore.instance.collection('buses');
      await col.doc(id).delete();
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }

  Future<void> assignDriver(String busId, String? driverId) async {
    final idx = _buses.indexWhere((b) => b.id == busId);
    if (idx == -1) return;
    _buses[idx].assignedDriverId = driverId;
    try {
      final col = FirebaseFirestore.instance.collection('buses');
      await col.doc(busId).update({'assignedDriverId': driverId});
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }

  Future<void> addSchedule(String busId, String time) async {
    final idx = _buses.indexWhere((b) => b.id == busId);
    if (idx == -1) return;
    final bus = _buses[idx];
    if (!bus.schedule.contains(time)) bus.schedule.add(time);
    try {
      final col = FirebaseFirestore.instance.collection('buses');
      await col.doc(busId).update({'schedule': FieldValue.arrayUnion([time])});
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }

  Future<void> removeSchedule(String busId, String time) async {
    final idx = _buses.indexWhere((b) => b.id == busId);
    if (idx == -1) return;
    final bus = _buses[idx];
    bus.schedule.remove(time);
    try {
      final col = FirebaseFirestore.instance.collection('buses');
      await col.doc(busId).update({'schedule': FieldValue.arrayRemove([time])});
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }
}
