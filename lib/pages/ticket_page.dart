import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

class TicketPage extends StatefulWidget {
  final String busName;
  final String busId;
  final String fare;
  final String qrPayload;

  const TicketPage({super.key, required this.busName, required this.busId, required this.fare, required this.qrPayload});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final GlobalKey _ticketKey = GlobalKey();
  bool _saving = false;

  Future<String?> _saveTicketAsPng() async {
    try {
      setState(() => _saving = true);
      final boundary = _ticketKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ticket_${widget.busId}_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      return null;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Ticket')),
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: _ticketKey,
                child: Card(
                  color: const Color(0xFF0E1112),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.busName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Bus ID: ${widget.busId}', style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 6),
                        Text('Fare: ${widget.fare}', style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 18),
                        QrImageView(
                          data: widget.qrPayload,
                          size: 200,
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF0E1112),
                        ),
                        const SizedBox(height: 12),
                        const Text('Show this QR at boarding', style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400], padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _saving
                        ? null
                        : () async {
                            final path = await _saveTicketAsPng();
                            if (path != null) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved ticket to $path')));
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save ticket')));
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _saving ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator()) : const Text('Download Ticket', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
