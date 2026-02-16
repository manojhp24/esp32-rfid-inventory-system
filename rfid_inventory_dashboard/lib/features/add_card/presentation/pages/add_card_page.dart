import 'package:flutter/material.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/app_toast.dart';

class AddCardPage extends StatefulWidget {
  final String? editKey;
  final Map<String, dynamic>? existingData;

  const AddCardPage({super.key, this.editKey, this.existingData});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController cardUidController = TextEditingController();
  final TextEditingController handlerController = TextEditingController();

  String? selectedRole;
  String? selectedStatus;

  final List<String> roles = ["Shopkeeper", "Manager", "Admin", "Security"];
  final List<String> statuses = ["Authorized", "Unauthorized"];

  @override
  void initState() {
    super.initState();

    if (widget.existingData != null) {
      cardUidController.text = widget.existingData!['cardUid'] ?? '';
      handlerController.text = widget.existingData!['name'] ?? '';

      selectedRole = roles.firstWhere(
        (r) => r.toLowerCase() == widget.existingData!['role'],
        orElse: () => roles.first,
      );

      selectedStatus = statuses.firstWhere(
        (s) => s.toLowerCase() == widget.existingData!['status'],
        orElse: () => statuses.first,
      );
    }
  }

  @override
  void dispose() {
    cardUidController.dispose();
    handlerController.dispose();
    super.dispose();
  }

  String sanitizeUid(String uid) {
    return uid.trim().replaceAll(RegExp(r'[.#$\[\]/]'), '_');
  }

  Future<void> _saveCard() async {
    final uid = sanitizeUid(cardUidController.text).toUpperCase();
    final name = handlerController.text.trim().toLowerCase();
    final role = selectedRole?.toLowerCase();
    final status = selectedStatus?.toLowerCase();

    if (uid.isEmpty || name.isEmpty || role == null || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseService.addHandler(uid, {
      "cardUid": uid,
      "name": name,
      "role": role,
      "status": status,
      "updatedAt": DateTime.now().toIso8601String(),
    });

    AppToast.showSuccess(context, "Saved successfully");

    if (!mounted) return;

    // ✅ THIS keeps NavigationRail intact
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingData == null ? "Add Card" : "Edit Card"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cardUidController,
                    enabled: widget.existingData == null,
                    decoration: const InputDecoration(
                      labelText: "Card UID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: handlerController,
                    decoration: const InputDecoration(
                      labelText: "Handler Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    hint: const Text("Select Role"),
                    items: roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedRole = v),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    hint: const Text("Select Status"),
                    items: statuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedStatus = v),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 160,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveCard,
                  child: Text(
                    widget.existingData == null ? "Add" : "Save",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
