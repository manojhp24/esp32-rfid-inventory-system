import 'package:flutter/material.dart';
import '../../../../core/utils/stat_card.dart';

class LogDetailsPage extends StatelessWidget {
  final String logId;
  final Map<String, dynamic> logData;

  const LogDetailsPage({super.key, required this.logId, required this.logData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Details")),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            StatCard(
              title: "Log ID",
              value: logId,
              icon: Icons.confirmation_number,
              iconColor: Colors.deepPurple,
            ),
            StatCard(
              title: "Handler UID",
              value: logData['handler'] ?? "-",
              icon: Icons.person,
              iconColor: Colors.blue,
            ),
            StatCard(
              title: "Item UID",
              value: logData['item'] ?? "-",
              icon: Icons.inventory_2,
              iconColor: Colors.orange,
            ),
            StatCard(
              title: "Action",
              value: logData['action'] ?? "-",
              icon: Icons.sync_alt,
              iconColor: logData['action'] == "IN" ? Colors.green : Colors.red,
            ),
            StatCard(
              title: "Time",
              value: logData['time'].toString(),
              icon: Icons.access_time,
              iconColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
