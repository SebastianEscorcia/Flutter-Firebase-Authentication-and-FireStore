class Persona {
  final String uid; // Mismo que el UID de Firebase Auth
  final String nombre;
  final String email;
  final DateTime fechaNacimiento;
  final List<String> mascotasIds; // Referencias a mascotas

  Persona({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.fechaNacimiento,
    this.mascotasIds = const [],
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'email': email,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'mascotasIds': mascotasIds,
    };
  }

  // Crear desde Firestore
  factory Persona.fromMap(String uid, Map<String, dynamic> map) {
    return Persona(
      uid: uid,
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      fechaNacimiento: DateTime.parse(map['fechaNacimiento']),
      mascotasIds: List<String>.from(map['mascotasIds'] ?? []),
    );
  }
}