import 'package:flutter/foundation.dart';

import '../../data/models/peet.dart';
import '../../services/mascota_services.dart';

class MascotaProvider with ChangeNotifier {
  final MascotaService _service;
  List<Mascota> _mascotas = [];
  bool _isLoading = false;
  String? _error;

  MascotaProvider(this._service);

  List<Mascota> get mascotas => _mascotas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarMascotas(String personaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _mascotas = await _service.obtenerMascotas(personaId);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar mascotas: $e';
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarMascota(Mascota mascota) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.registrarMascota(mascota);
      _mascotas.add(mascota);
      _error = null;
    } catch (e) {
      _error = 'Error al registrar mascota: $e';
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}