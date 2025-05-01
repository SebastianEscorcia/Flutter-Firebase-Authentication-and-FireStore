import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/person_provider.dart';


class NombreField extends StatelessWidget {
  final TextEditingController controller;

  const NombreField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonaProvider>(
      builder: (context, provider, _) {
        if (provider.persona != null && controller.text.isEmpty) {
          controller.text = provider.persona!.nombre;
        }
        return TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre Completo',
            icon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
        );
      },
    );
  }
}
