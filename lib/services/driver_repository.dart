import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  final String id;
  final String name;
  final String licence; // DL number

  Driver({required this.id, required this.name, required this.licence});

  Map<String, String> toJson() => {'id': id, 'name': name, 'licence': licence};
  static Driver fromJson(Map<String, dynamic> j) => Driver(id: j['id'] as String, name: j['name'] as String, licence: j['licence'] as String);
}

class DriverRepository extends ChangeNotifier {
  static DriverRepository? _instance;
  static DriverRepository? instanceOrNull() => _instance;
  final List<Driver> _drivers = [];

  DriverRepository._();

  static Future<DriverRepository> getInstance() async {
    if (_instance != null) return _instance!;
    final r = DriverRepository._();
    try {
      await r._loadFromFirestore();
    } catch (_) {
      await r._load();
    }
    _instance = r;
    return r;
  }

  List<Driver> get drivers => List.unmodifiable(_drivers);

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/drivers.json');
  }

  Future<void> _load() async {
    try {
      final f = await _file();
      if (await f.exists()) {
        final s = await f.readAsString();
        final data = json.decode(s) as List<dynamic>;
        _drivers.clear();
        for (final item in data) {
          _drivers.add(Driver.fromJson(item as Map<String, dynamic>));
        }
      }
    } catch (e) {
      if (kDebugMode) print('Failed to load drivers: $e');
    }
    notifyListeners();
  }

  Future<void> _loadFromFirestore() async {
    final col = FirebaseFirestore.instance.collection('drivers');
    final snapshot = await col.get();
    _drivers.clear();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      _drivers.add(Driver(id: doc.id, name: data['name'] as String? ?? '', licence: data['licence'] as String? ?? ''));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final f = await _file();
    final data = _drivers.map((d) => d.toJson()).toList();
    await f.writeAsString(json.encode(data));
  }

  Future<void> addDriver(Driver d) async {
    _drivers.add(d);
    try {
      final col = FirebaseFirestore.instance.collection('drivers');
      await col.doc(d.id).set({'name': d.name, 'licence': d.licence});
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }

  Future<void> removeDriver(String id) async {
    _drivers.removeWhere((d) => d.id == id);
    try {
      final col = FirebaseFirestore.instance.collection('drivers');
      await col.doc(id).delete();
    } catch (_) {
      await _save();
    }
    notifyListeners();
  }
}
