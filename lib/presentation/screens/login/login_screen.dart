import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // La columna solo ocupa el espacio necesario
          mainAxisAlignment:
              MainAxisAlignment
                  .center, // Los elementos están centrados dentro de la columna
          children: [
            Text(
              "Presiona el botón para comenzar la aventura",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),
            // Mostrar error solo si no fue cancelación
            if (authProvider.errorMessage.isNotEmpty &&
                !authProvider.userCancelledLogin)
              Text(
                authProvider.errorMessage,
                style: TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),
  
            // Mostrar botón de login
            ElevatedButton(
              onPressed:
                  authProvider.isLoading
                      ? null
                      : () => authProvider.signInWithGoogle(),
              child:
                  authProvider.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Iniciar con Google'),
            ),
          ],
        ),
      ),
    );
  }
}
