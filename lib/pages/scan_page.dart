import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _flashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1112),
        title: const Text('Scan Ticket', style: TextStyle(color: Colors.white)),
        actions: [Padding(padding: const EdgeInsets.only(right:12.0), child: Center(child: Text('QR validation', style: TextStyle(color: Colors.white70)))),],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Camera view placeholder
              Container(
                height: 260,
                decoration: BoxDecoration(color: const Color(0xFF0E1112), borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.camera_alt_outlined, size: 36, color: Colors.white70),
                      SizedBox(height: 8),
                      Text('Camera View', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E1112),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => setState(() => _flashOn = !_flashOn),
                      child: Text(_flashOn ? 'Flash: On' : 'Flash', style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E1112),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => _showManualCodeDialog(),
                      child: const Text('Manual Code', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF0E1112), borderRadius: BorderRadius.circular(12)),
                child: const Text('Tip: Hold steady ~20cm from QR.', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0E1112),
        title: const Text('Manual Code', style: TextStyle(color: Colors.white)),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Enter code', hintStyle: TextStyle(color: Colors.white54), filled: true, fillColor: Color(0xFF141617)),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close', style: TextStyle(color: Colors.white70)))],
      ),
    );
  }
}
