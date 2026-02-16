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
            // 🔹 Handler Name
            StatCard(
              title: "Handler",
              value: logData['handlerName'] ?? logData['handler'] ?? "-",
              icon: Icons.person,
              iconColor: Colors.blue,
            ),

            // 🔹 Handler UID (optional but useful)
            StatCard(
              title: "Handler UID",
              value: logData['handlerId'] ?? logData['handler'] ?? "-",
              icon: Icons.badge,
              iconColor: Colors.blueGrey,
            ),

            // 🔹 Item Name
            StatCard(
              title: "Item",
              value: logData['itemName'] ?? logData['item'] ?? "-",
              icon: Icons.inventory_2,
              iconColor: Colors.orange,
            ),

            // 🔹 Item UID (optional)
            StatCard(
              title: "Item UID",
              value: logData['itemId'] ?? logData['item'] ?? "-",
              icon: Icons.qr_code,
              iconColor: Colors.orangeAccent,
            ),

            // 🔹 Action
            StatCard(
              title: "Action",
              value: logData['action'] ?? "-",
              icon: Icons.sync_alt,
              iconColor: logData['action'] == "IN" ? Colors.green : Colors.red,
            ),

            // 🔹 Time
            StatCard(
              title: "Time",
              value: _formatTime(logData['time']),
              icon: Icons.access_time,
              iconColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // helper to format time nicely
  String _formatTime(dynamic time) {
    if (time == null) return '-';

    int ts = int.tryParse(time.toString()) ?? 0;

    // OLD logs safety check
    if (ts < 1000000000000) {
      return 'Old log';
    }

    final date = DateTime.fromMillisecondsSinceEpoch(ts);
    return "${date.day}-${date.month}-${date.year} "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
