import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../../../../core/services/firebase_service.dart';
import '../../../add_card/presentation/pages/add_card_page.dart';

class HandlersPage extends StatelessWidget {
  const HandlersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ ADD BUTTON (opens AddCardPage correctly)
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Handler"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCardPage()),
          );
        },
      ),

      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Handlers",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: FirebaseAnimatedList(
                query: FirebaseService.handlersRef(),
                itemBuilder: (context, snapshot, animation, index) {
                  final data = Map<String, dynamic>.from(snapshot.value as Map);
                  final key = snapshot.key!;

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        data['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${data['role']} - ${data['status']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddCardPage(
                                    editKey: key,
                                    existingData: data,
                                  ),
                                ),
                              );
                            },
                          ),

                          // ✅ DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseService.deleteHandler(key);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
