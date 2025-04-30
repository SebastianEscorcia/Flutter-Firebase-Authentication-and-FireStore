import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import 'auth_provider.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Mostrar un loading mientras se verifica el estado de autenticación
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Usuario autenticado - ir a Home
    if (authProvider.user != null) {
      return const HomeScreen();
    }
    
    // Usuario no autenticado - ir a Login
    return const LoginScreen();
  }
}