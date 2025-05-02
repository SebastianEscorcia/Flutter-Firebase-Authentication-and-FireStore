import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/models/person.dart';
import '../../providers/auth_provider.dart';
import '../../providers/person_provider.dart';
import '../../widgets/register_person/email_field.dart';
import '../../widgets/register_person/fecha_nacimiento_field.dart';
import '../../widgets/register_person/nombre_field.dart';

class RegistroPersonaScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  RegistroPersonaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final personaProvider = Provider.of<PersonaProvider>(context);
    /*
    if (personaProvider.persona != null) {
      _nombreController.text = personaProvider.persona!.nombre;
      _emailController.text = personaProvider.persona!.email;
      DateTime fechaNacimiento = DateTime.parse(
        personaProvider.persona!.fechaNacimiento.toString(),
      );
      String fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaNacimiento);
      _fechaNacimientoController.text = fechaFormateada;
    }
    */

    //esperar el usuario antes de construir el formulario
    if (authProvider.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          personaProvider.persona != null
              ? "editar perfil"
              : "Completar Perfil",
        ),
        actions: [
          if (personaProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // WIDGETS TextFormField
              NombreField(controller: _nombreController),
              const SizedBox(height: 16),

              EmailField(controller: _emailController),

              const SizedBox(height: 16),

              FechaNacimientoField(controller: _fechaNacimientoController),

              const SizedBox(height: 24),
              if (personaProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    personaProvider.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed:
                    personaProvider.isLoading
                        ? null
                        : () async {
                          if (_formKey.currentState!.validate()) {
                            final currentUser = authProvider.user;
                            if (currentUser == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Usuario no autenticado. Intenta de nuevo.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final nuevaPersona = Persona(
                              uid: currentUser.uid,
                              nombre: _nombreController.text,
                              email: _emailController.text,
                              fechaNacimiento: DateFormat(
                                'dd/MM/yyyy',
                              ).parse(_fechaNacimientoController.text),
                            );

                            await personaProvider.crearOActualizarPersona(
                              nuevaPersona,
                            );

                            if (personaProvider.error == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Perfil actualizado correctamente',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(personaProvider.error!),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },

                child: const Text('Guardar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
