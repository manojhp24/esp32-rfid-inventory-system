import 'package:firebase_database/firebase_database.dart';

// class FirebaseService {
//   static final _db = FirebaseDatabase.instance.ref();

//   // Items
//   static Future<void> addItem(Map<String, dynamic> item) async {
//     await _db.child('items').push().set(item);
//   }

//   static DatabaseReference itemsRef() {
//     return _db.child('items');
//   }

//   static Future<void> deleteItem(String key) async {
//     await _db.child('items').child(key).remove();
//   }

//   // Handlers
//   static Future<void> addHandler(Map<String, dynamic> handler) async {
//     await _db.child('handlers').push().set(handler);
//   }

//   static DatabaseReference handlersRef() {
//     return _db.child('handlers');
//   }

//   static Future<void> deleteHandler(String key) async {
//     await _db.child('handlers').child(key).remove();
//   }
// }

class FirebaseService {
  static final _db = FirebaseDatabase.instance.ref();

  // ================= ITEMS =================

  static Future<void> addItem(String uid, Map<String, dynamic> item) async {
    await _db.child('items').child(uid).set(item);
  }

  static DatabaseReference itemsRef() {
    return _db.child('items');
  }

  static Future<void> deleteItem(String uid) async {
    await _db.child('items').child(uid).remove();
  }

  // ================= HANDLERS =================

  static Future<void> addHandler(
    String uid,
    Map<String, dynamic> handler,
  ) async {
    await _db.child('handlers').child(uid).set(handler);
  }

  static DatabaseReference handlersRef() {
    return _db.child('handlers');
  }

  static Future<void> deleteHandler(String uid) async {
    await _db.child('handlers').child(uid).remove();
  }

  // ================= LOGS =================

  static DatabaseReference logsRef() {
    return _db.child('logs');
  }
}
