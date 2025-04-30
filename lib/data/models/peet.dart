class Mascota {
  final String id;
  final String nombre;
  final String tipo;
  final int edad;
  final String duenioId; // UID del dueño (Persona)

  Mascota({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.edad,
    required this.duenioId,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'edad': edad,
      'duenioId': duenioId,
    };
  }

  // Crear desde Firestore
  factory Mascota.fromMap(String id, Map<String, dynamic> map) {
    return Mascota(
      id: id,
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? '',
      edad: map['edad'] ?? 0,
      duenioId: map['duenioId'] ?? '',
    );
  }
}