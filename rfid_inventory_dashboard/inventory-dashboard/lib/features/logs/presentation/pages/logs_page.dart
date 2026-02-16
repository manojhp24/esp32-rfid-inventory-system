import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../../../../core/services/firebase_service.dart';
import 'log_details_page.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Logs",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseService.logsRef(),
              defaultChild: const Center(child: CircularProgressIndicator()),
              itemBuilder: (context, snapshot, animation, index) {
                if (!snapshot.exists) return const SizedBox();

                final data = Map<String, dynamic>.from(snapshot.value as Map);
                final logId = snapshot.key!;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LogDetailsPage(logId: logId, logData: data),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: const Icon(Icons.history, color: Colors.indigo),
                      ),
                      title: Text(
                        data['handler'] ?? 'Unknown Handler',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Action: ${data['action']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
