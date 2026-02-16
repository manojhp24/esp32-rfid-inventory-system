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

    if (uid.isEmpty ||
        name.isEmpty ||
        selectedRole == null ||
        selectedStatus == null) {
      AppToast.showSuccess(context, "Please fill all fields");
      return;
    }

    await FirebaseService.addHandler(uid, {
      "cardUid": uid,
      "name": name,
      "role": selectedRole!.toLowerCase(),
      "status": selectedStatus!.toLowerCase(),
      "updatedAt": DateTime.now().toIso8601String(),
    });

    AppToast.showSuccess(context, "Saved successfully");

    // ✅ DO NOT POP — THIS PAGE IS PART OF DASHBOARD LAYOUT
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingData != null;

    return Material(
      color: Colors.grey.shade100,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      isEdit ? "Edit Card" : "Add Card",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      "Enter card and handler details",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 24),

                    /// UID + Name
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: cardUidController,
                            enabled: !isEdit,
                            decoration: const InputDecoration(
                              labelText: "Card UID",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 350,
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

                    /// Role + Status
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                            value: selectedRole,
                            hint: const Text("Select Role"),
                            items: roles
                                .map((r) =>
                                DropdownMenuItem(value: r, child: Text(r)))
                                .toList(),
                            onChanged: (v) => setState(() => selectedRole = v),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            hint: const Text("Select Status"),
                            items: statuses
                                .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
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

                    /// Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: _saveCard,
                          icon: const Icon(Icons.save),
                          label: Text(isEdit ? "Save Changes" : "Add Card"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
