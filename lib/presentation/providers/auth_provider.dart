import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  User? _user;
  String _errorMessage = '';
  bool _isLoading = true;
  bool _userCancelledLogin = false;

  User? get user => _user;
  String get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;
  bool get userCancelledLogin => _userCancelledLogin;
  AuthProvider() {
    // Escuchar cambios en el estado de autenticación
    _authServices.user.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      _userCancelledLogin = false;
      notifyListeners();

      final user = await _authServices.signInWithGoogle(_errorMessage);

      if (user == null) {
        _userCancelledLogin = true;
        _isLoading = false;
        _errorMessage = 'No se pudo iniciar sesión con Google';
        notifyListeners();
      }

      return user;
    } catch(e){
      if (e.toString().contains('popud_closed')){
        _userCancelledLogin= true;
        _errorMessage= '';
        _isLoading= false;
      }else if(e is FirebaseAuthException){
        _errorMessage = 'Error ${e.message}';
      } else{
        _errorMessage = 'Haz cancelado el inicio de sesión';
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authServices.signOut();
  }
}
