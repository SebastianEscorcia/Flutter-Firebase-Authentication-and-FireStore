import 'package:flutter/foundation.dart';

import '../../data/models/person.dart';
import '../../services/person_services.dart';

class PersonaProvider with ChangeNotifier {
  final PersonaServices _service;
  Persona? _persona;
  bool _isLoading = false;
  String? _error;

  PersonaProvider(this._service);

  Persona? get persona => _persona;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarPersona(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _persona = await _service.obtenerPersona(uid);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar persona: $e';
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearOActualizarPersona(Persona persona) async {
    _isLoading = true;
    notifyListeners();

    try {
      final existe = await _service.obtenerPersona(persona.uid);
      if (existe == null) {
        await _service.crearPersona(persona);
      } else {
        await _service.actualizarPersona(persona);
      }

      // Recarga desde Firestore para asegurar datos frescos
      _persona = await _service.obtenerPersona(persona.uid);
      _error = null;
    } catch (e) {
      _error = 'Error al guardar persona: $e';
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
