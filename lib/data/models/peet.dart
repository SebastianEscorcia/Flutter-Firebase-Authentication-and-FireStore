class Mascota {
  final String id;
  final String nombre;
  final String tipo;
  final int edad;
  final String duenioId;
  final DateTime fechaRegistro;

  Mascota({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.edad,
    required this.duenioId,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'edad': edad,
      'duenioId': duenioId,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory Mascota.fromMap(String id, Map<String, dynamic> map) {
    return Mascota(
      id: id,
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? '',
      edad: map['edad'] ?? 0,
      duenioId: map['duenioId'] ?? '',
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }
}