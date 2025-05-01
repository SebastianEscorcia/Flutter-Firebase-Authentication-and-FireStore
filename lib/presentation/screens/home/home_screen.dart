import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_routes.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    //final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
        
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 1.1,
            children: [
              Title(
                color: Colors.cyan,
                child: Text(
                  "Bienvenido a la aplicación de firebase auth + fireStore",
                ),
              ),
              Container(
                alignment: Alignment(20, 30),
                margin: EdgeInsets.all(22.2),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.registerPerson);
                },
                child: Text("Actualizar Perfil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
