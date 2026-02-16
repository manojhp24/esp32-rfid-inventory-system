import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/widgets/app_navigation.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/items/presentation/pages/items_page.dart';
import 'features/handlers/presentation/pages/handlers_page.dart';
import 'features/logs/presentation/pages/logs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDKXCuL4ln_uyNcJueYGp6y_eheipPQriU",
      authDomain: "rfidinventorysystem-iot.firebaseapp.com",
      databaseURL:
          "https://rfidinventorysystem-iot-default-rtdb.firebaseio.com",
      projectId: "rfidinventorysystem-iot",
      storageBucket: "rfidinventorysystem-iot.firebasestorage.app",
      messagingSenderId: "1031827008582",
      appId: "1:1031827008582:web:aba67f895f4fc2d7192e47",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RFID Inventory',
      home: DashboardShell(),
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int selectedIndex = 0;

  final pages = [DashboardPage(), ItemsPage(), HandlersPage(), LogsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: selectedIndex,
            onSelect: (i) => setState(() => selectedIndex = i),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
