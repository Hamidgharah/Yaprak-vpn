import 'package:flutter/material.dart';

void main() {
  runApp(const YaprakVpnApp());
}

class YaprakVpnApp extends StatelessWidget {
  const YaprakVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yaprak VPN',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF10B981),
      ),
      home: const VpnHomeScreen(),
    );
  }
}

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

class _VpnHomeScreenState extends State<VpnHomeScreen> {
  bool isConnected = false;
  bool isConnecting = false;

  void toggleConnection() async {
    setState(() {
      isConnecting = true;
    });

    // شبیه‌سازی اتصال به سرور VLESS + Reality
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isConnecting = false;
      isConnected = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yaprak VPN', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnecting
                  ? 'CONNECTING...'
                  : (isConnected ? 'CONNECTED' : 'DISCONNECTED'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isConnected
                    ? const Color(0xFF10B981)
                    : (isConnecting ? Colors.amber : Colors.redAccent),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: isConnecting ? null : toggleConnection,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected
                      ? const Color(0xFF10B981)
                      : const Color(0xFF1E293B),
                  boxShadow: [
                    BoxShadow(
                      color: isConnected
                          ? const Color(0xFF10B981).withOpacity(0.5)
                          : Colors.black26,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: isConnecting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Icon(
                          Icons.power_settings_new,
                          size: 80,
                          color: isConnected ? Colors.white : Colors.grey[500],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Color(0xFF10B981)),
                  SizedBox(width: 10),
                  Text('VLESS + Reality Server',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
