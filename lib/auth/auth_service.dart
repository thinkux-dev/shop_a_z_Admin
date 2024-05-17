import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_a_z/db/db_helper.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<bool> loginAdmin(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    // This compare if the admin user id matches with the document name of the Admins collection(uid)
    return DbHelper.isAdmin(credential.user!.uid);
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}