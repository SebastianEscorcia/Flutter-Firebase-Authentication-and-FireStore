import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../providers/mascota_provider.dart';
import '../register_peets/register_peet_screen.dart';

class ListaMascotasScreen extends StatelessWidget {
  const ListaMascotasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mascotaProvider = Provider.of<MascotaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroMascotaScreen()),
            ),
          ),
        ],
      ),
      body: mascotaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mascotaProvider.mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotaProvider.mascotas[index];
                return ListTile(
                  title: Text(mascota.nombre),
                  subtitle: Text('${mascota.tipo} - ${mascota.edad} años'),
                  leading: const Icon(Icons.pets),
                );
              },
            ),
    );
  }
}