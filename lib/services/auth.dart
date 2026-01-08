import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:primeform/models/user.dart' as app;

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  app.User? _userFromFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return app.User(id: user.uid);
  }

  Stream<app.User?> get user =>
      _auth.authStateChanges().map(_userFromFirebaseUser);

  Future<app.User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebaseUser(cred.user);
  }

  Future<void> signOut() async => _auth.signOut();
}
