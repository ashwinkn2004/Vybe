import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔐 Check if accessToken is stored locally
  Future<bool> isLoggedIn() async {
    final box = await Hive.openBox('auth');
    final token = box.get('accessToken');
    return token != null && token.isNotEmpty;
  }

  // 📥 Save accessToken in Hive
  Future<void> saveToken(String token) async {
    final box = await Hive.openBox('auth');
    await box.put('accessToken', token);
  }

  // 🔓 Sign out from Firebase and Hive
  Future<void> signOut() async {
    await _auth.signOut();
    final box = await Hive.openBox('auth');
    await box.delete('accessToken');
  }

  // 📧 Register using Email & Password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final token = await credential.user?.getIdToken();
    if (token != null) {
      await saveToken(token);
    }
    return credential;
  }

  // 🔐 Google Sign-in
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final token = await userCredential.user?.getIdToken();
    if (token != null) {
      await saveToken(token);
    }

    return userCredential;
  }
}
