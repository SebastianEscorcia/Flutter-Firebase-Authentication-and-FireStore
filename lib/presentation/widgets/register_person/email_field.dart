import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/person_provider.dart';


class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonaProvider>(
      builder: (context, provider, _) {
        if (provider.persona != null && controller.text.isEmpty) {
          controller.text = provider.persona!.email;
        }
        return TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) return 'Campo requerido';
            if (!value.contains('@')) return 'Email inválido';
            return null;
          },
        );
      },
    );
  }
}
