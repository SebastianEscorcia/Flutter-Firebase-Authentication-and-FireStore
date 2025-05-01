import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/person_provider.dart';


class FechaNacimientoField extends StatelessWidget {
  final TextEditingController controller;

  const FechaNacimientoField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonaProvider>(
      builder: (context, provider, _) {
        if (provider.persona != null && controller.text.isEmpty) {
          final fecha = DateTime.parse(provider.persona!.fechaNacimiento.toString());
          controller.text = DateFormat('dd/MM/yyyy').format(fecha);
        }

        return TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Fecha de Nacimiento',
            icon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          onTap: () async {
            final fecha = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: const Locale('es', 'ES'),
            );
            if (fecha != null) {
              controller.text = DateFormat('dd/MM/yyyy', 'es_ES').format(fecha);
            }
          },
          validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
        );
      },
    );
  }
}
