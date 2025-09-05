import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'ticket_page.dart';
import '../services/driver_repository.dart';
import '../services/bus_repository.dart';

class ConfirmBookingPage extends StatelessWidget {
  final String busName;
  final String busId;
  final String fare;

  const ConfirmBookingPage({super.key, required this.busName, required this.busId, required this.fare});

  String _generatePayload() {
    // Simple payload: JSON-like string. Change to signed token as needed.
    final payload = '{"bus":"$busName","id":"$busId","fare":"$fare","ts":"${DateTime.now().toIso8601String()}"}';
    return payload;
  }

  @override
  Widget build(BuildContext context) {
    final payload = _generatePayload();
    // try to resolve assigned driver
    String? driverName;
    String? driverLicence;
    try {
  final repo = DriverRepository.instanceOrNull();
  final busRepo = BusRepository.instanceOrNull();
      if (busRepo != null) {
        final buses = busRepo.buses.where((b) => b.id == busId).toList();
        if (buses.isNotEmpty) {
          final bus = buses.first;
          if (bus.assignedDriverId != null && repo != null) {
            final drivers = repo.drivers.where((x) => x.id == bus.assignedDriverId).toList();
            if (drivers.isNotEmpty) {
              final d = drivers.first;
              driverName = d.name;
              driverLicence = d.licence;
            }
          }
        }
      }
    } catch (_) {}
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: const Color(0xFF0E1112),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(busName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Bus ID: $busId', style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text('Fare: $fare', style: const TextStyle(color: Colors.white70)),
                        if (driverName != null) ...[
                          const SizedBox(height: 8),
                          Text('Driver: $driverName', style: const TextStyle(color: Colors.white70)),
                          if (driverLicence != null) Text('Licence: $driverLicence', style: const TextStyle(color: Colors.white70)),
                        ],
                        const SizedBox(height: 18),
                        QrImageView(
                          data: payload,
                          size: 160.0,
                          backgroundColor: const Color(0xFF0E1112),
                          foregroundColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text('QR preview — will be used as the ticket after confirmation', style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400], padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      // Navigate to TicketPage with generated qr payload string
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => TicketPage(busName: busName, busId: busId, fare: fare, qrPayload: payload)));
                    },
                    child: const Text('Confirm & Generate QR Code', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
