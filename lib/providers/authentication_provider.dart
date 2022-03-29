import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider {
  final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  void dispose() {}

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> getCurrentUser() async {
    print(_firebaseAuth.currentUser!.uid);
    return _firebaseAuth.currentUser;
  }

  Future<bool> signOutUser() async {
    try {
      Future.wait([
        _firebaseAuth.signOut(),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
