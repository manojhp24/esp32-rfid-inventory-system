import 'package:flutter/material.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/app_toast.dart';

class AddItemPage extends StatefulWidget {
  final String? editKey;
  final Map? existingData;

  const AddItemPage({super.key, this.editKey, this.existingData});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController itemUidController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();

  String? selectedCategory;
  String? selectedStatus;

  final List<String> categories = [
    "Electronics",
    "Grocery",
    "Clothing",
    "Furniture",
  ];

  final List<String> statuses = ["Active", "Inactive"];

  @override
  void initState() {
    super.initState();

    if (widget.existingData != null) {
      itemUidController.text = widget.existingData!['uid'] ?? '';
      itemNameController.text = widget.existingData!['name'] ?? '';

      final cat = widget.existingData!['category'];
      final stat = widget.existingData!['status'];

      selectedCategory = categories.firstWhere(
        (c) => c.toLowerCase() == cat,
        orElse: () => categories.first,
      );

      selectedStatus = statuses.firstWhere(
        (s) => s.toLowerCase() == stat,
        orElse: () => statuses.first,
      );
    }
  }

  String sanitizeUid(String uid) {
    return uid.trim().replaceAll(RegExp(r'[.#$\[\]/]'), '_');
  }

  Future<void> _saveItem() async {
    final uid = sanitizeUid(itemUidController.text).toUpperCase();
    final name = itemNameController.text.trim().toLowerCase();
    final category = selectedCategory?.toLowerCase();
    final status = selectedStatus?.toLowerCase();

    if (uid.isEmpty || name.isEmpty || category == null || status == null) {
      AppToast.showSuccess(context, "Fill all fields");
      return;
    }

    await FirebaseService.addItem(uid, {
      "uid": uid,
      "name": name,
      "category": category,
      "status": status,
      "createdAt": DateTime.now().toIso8601String(),
    });

    Navigator.pop(context);
    AppToast.showSuccess(context, "Saved successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemUidController,
                    decoration: const InputDecoration(
                      labelText: "Item UID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: itemNameController,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
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
                    value: selectedCategory,
                    hint: const Text("Category"),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    hint: const Text("Status"),
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
            SizedBox(
              width: 160,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveItem,
                child: const Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
