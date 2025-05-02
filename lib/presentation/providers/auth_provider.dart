import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/auth_services.dart';
import '../screens/register_person/register_person_screen.dart';
import 'person_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthServices _authServices;
  User? _user;
  String _errorMessage = '';
  bool _isLoading = true;
  bool _userCancelledLogin = false;
  bool _needsProfileCompletion = false;

  AuthProvider(this._authServices) {
    _initAuth();
  }

  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get userCancelledLogin => _userCancelledLogin;
  bool get needsProfileCompletion => _needsProfileCompletion;

  Future<void> _initAuth() async {
    _authServices.user.listen((User? user) async {
      _user = user;
      _isLoading = false;

      if (user != null) {
        // Verificar si necesita completar perfil
        await _checkProfileCompletion(user);
      }

      notifyListeners();
    });
  }

  Future<void> _checkProfileCompletion(User user) async {
    if (navigatorKey.currentContext == null) {
      if (kDebugMode) print('Contexto no disponible');
      return;
    }

    try {
      final personaProvider = Provider.of<PersonaProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      await personaProvider.cargarPersona(user.uid);
      _needsProfileCompletion = personaProvider.persona == null;

      if (_needsProfileCompletion) {
        Navigator.of(
          navigatorKey.currentContext!,
        ).push(MaterialPageRoute(builder: (_) => RegistroPersonaScreen()));
      }
    } catch (e) {
      if (kDebugMode) print('Error verificando perfil: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      _userCancelledLogin = false;
      _needsProfileCompletion = false;
      notifyListeners();

      final user = await _authServices.signInWithGoogle(_errorMessage);

      if (user == null) {
        _userCancelledLogin = true;
        _errorMessage = 'No se pudo iniciar sesión con Google';
        return null;
      }

      // Verificar si necesita completar perfil
      await _checkProfileCompletion(user);

      return user;
    } catch (e) {
      if (e.toString().contains('popup_closed')) {
        _userCancelledLogin = true;
        _errorMessage = '';
      } else if (e is FirebaseAuthException) {
        _errorMessage = 'Error: ${e.message}';
      } else {
        _errorMessage = 'Error desconocido al iniciar sesión';
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authServices.signOut();
    _isLoading= false;
    _user = null;
    print("Usuario actual: ${_user?.uid}");
    _needsProfileCompletion = false;
    notifyListeners();
  }
}
