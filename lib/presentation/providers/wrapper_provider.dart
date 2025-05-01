import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register_person/register_person_screen.dart';
import 'auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.needsProfileCompletion) {
      return RegistroPersonaScreen();
    } else if (authProvider.user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
