import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/services/firebase_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _buildCountCard(
                title: "Total Items",
                icon: Icons.inventory_2,
                color: Colors.blue,
                ref: FirebaseService.itemsRef(),
              ),
              const SizedBox(width: 24),
              _buildCountCard(
                title: "Handlers",
                icon: Icons.people,
                color: Colors.blue,
                ref: FirebaseService.handlersRef(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountCard({
    required String title,
    required IconData icon,
    required Color color,
    required DatabaseReference ref,
  }) {
    return StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        int count = 0;

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value as Map;
          count = data.length;
        }

        return SizedBox(
          width: 300,
          height: 150,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 30, color: color),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
