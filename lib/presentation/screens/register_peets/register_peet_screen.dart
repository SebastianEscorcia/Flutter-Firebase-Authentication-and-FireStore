import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/peet.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mascota_provider.dart';

class RegistroMascotaScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _tipoController = TextEditingController();
  final _edadController = TextEditingController();
  
  RegistroMascotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mascotaProvider = Provider.of<MascotaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Mascota'),
        actions: [
          if (mascotaProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  icon: Icon(Icons.pets),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo (Perro, Gato, etc.)',
                  icon: Icon(Icons.category),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  icon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (int.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (mascotaProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    mascotaProvider.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ElevatedButton(
                onPressed: mascotaProvider.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final nuevaMascota = Mascota(
                            id: FirebaseFirestore.instance.collection('mascotas').doc().id,
                            nombre: _nombreController.text,
                            tipo: _tipoController.text,
                            edad: int.parse(_edadController.text),
                            duenioId: authProvider.user!.uid,
                            fechaRegistro: DateTime.now(),
                          );

                          await mascotaProvider.agregarMascota(nuevaMascota);
                          
                          if (mascotaProvider.error == null) {
                            Navigator.pop(context);
                          }
                        }
                      },
                child: const Text('Registrar Mascota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}