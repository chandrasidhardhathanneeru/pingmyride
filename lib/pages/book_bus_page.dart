import 'package:flutter/material.dart';
import 'bus_list_page.dart';

class BookBusPage extends StatefulWidget {
  final Map<String, String>? bus;
  const BookBusPage({super.key, this.bus});

  @override
  State<BookBusPage> createState() => _BookBusPageState();
}

class _BookBusPageState extends State<BookBusPage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    if (widget.bus != null) {
      // If navigated from a suggestion, populate fields heuristically
      _fromController.text = 'Current';
      _toController.text = widget.bus!['route'] ?? '';
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (c, child) => Theme(data: Theme.of(context), child: child!),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time ?? TimeOfDay.now());
    if (t != null) setState(() => _time = t);
  }

  void _findBuses() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    if (from.isEmpty || to.isEmpty || _date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BusListPage(from: from, to: to, date: _date!, time: _time!)));
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.green[400]!;
    return Scaffold(
      appBar: AppBar(title: const Text('Book Bus'), backgroundColor: const Color(0xFF0E1112)),
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(
        child: Center(
          child: Card(
            color: const Color(0xFF0E1112),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _fromController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on, color: Colors.white70),
                      hintText: 'From',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF141617),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _toController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on, color: Colors.white70),
                      hintText: 'To',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF141617),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(color: const Color(0xFF141617), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white70),
                                const SizedBox(width: 8),
                                Text(_date == null ? 'Select date' : '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(color: const Color(0xFF141617), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white70),
                                const SizedBox(width: 8),
                                Text(_time == null ? 'Select time' : _time!.format(context), style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _findBuses,
                      style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Find Buses')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
