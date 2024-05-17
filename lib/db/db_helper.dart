import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_a_z/models/brand_model.dart';
import 'package:shop_a_z/models/telescope_model.dart';

import '../models/app_user_model.dart';
import '../models/cart_model.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionAdmin = 'Admins';
  static const String collectionUser = 'Users';
  static const String collectionTelescope = 'Telescopes';
  static const String collectionBrand = 'Brands';
  static const String collectionOrder = 'orders';
  static const String collectionCart = 'MyCartItems';

  static Future<bool> isAdmin(String uid) async {
    // You can use either "get()" or "snapshots()" method to get the collection fields.
    // but in this we make use of get() because we only want to get the field once.
    // you can use snapshots() when you deal with the database changes that should reflect the UI.
    final snapShot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapShot.exists;
  }

  static Future<void> addBrand(Brand brand) {
    final doc = _db.collection(collectionBrand).doc();
    brand.id = doc.id;
    return doc.set(brand.toJson());
  }

  static Future<void> addUser(AppUserModel appUserModel) {
    return _db.collection(collectionUser)
        .doc(appUserModel.uid)
        .set(appUserModel.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBrands() =>
    _db.collection(collectionBrand).snapshots();

  static Future<void> addTelescope(TelescopeModel telescopeModel) {
    final doc = _db.collection(collectionTelescope).doc();
    telescopeModel.id = doc.id;
    return doc.set(telescopeModel.toJson());
  }

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllTelescopes() =>
      _db.collection(collectionTelescope).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartItems(String uid) =>
      _db.collection(collectionUser).doc(uid)
          .collection(collectionCart).snapshots();

  static Future<void> updateTelescopeField(String id, Map<String, dynamic> map) {
    return _db.collection(collectionTelescope).doc(id).update(map);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
    _db.collection(collectionOrder)
        .orderBy('orderDate', descending: true)
        .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() =>
      _db.collection(collectionUser).snapshots();
}