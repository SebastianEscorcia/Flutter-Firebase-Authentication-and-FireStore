import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithGoogle(String mensaje) async {
    try {
      // clietId de console Cloud esta es para desarrollo
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(
            clientId: kIsWeb ? dotenv.env['GOOGLE_CLIENT_ID'] : null,
            scopes: ['email'],
          ).signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      mensaje = ('Error al iniciar sesión con Google: ${e.message}');
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _auth.signOut();
  }
}
