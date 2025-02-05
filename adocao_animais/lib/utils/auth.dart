import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount? currentUser;
  bool loading = false;

  // Login com Google
  Future<void> handleSignIn() async {
    try {
      loading = true;
      notifyListeners();

      // Inicia o fluxo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Login cancelado pelo usuário
        loading = false;
        notifyListeners();
        return;
      }
      currentUser = googleUser;

      // Obtém as credenciais de autenticação do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz login no Firebase com as credenciais do Google
      await _firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print('Erro ao fazer login: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> handleSignOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    currentUser = null;
    notifyListeners();
  }

  // Retorna o estado atual do login
  User? get firebaseUser => _firebaseAuth.currentUser;

  bool get isSignedIn => firebaseUser != null;
}
