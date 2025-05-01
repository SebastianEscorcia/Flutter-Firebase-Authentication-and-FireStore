import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/peet.dart';

class MascotaService {
  final String mascotasCollection = 'mascotas';
  final String personasCollection = 'personas';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarMascota(Mascota mascota) async {
    final batch = _firestore.batch();
    
    // Registrar la mascota
    final mascotaRef = _firestore.collection(mascotasCollection).doc(mascota.id);
    batch.set(mascotaRef, mascota.toMap());
    
    // Actualizar referencia en la persona
    final personaRef = _firestore.collection(personasCollection).doc(mascota.duenioId);
    batch.update(personaRef, {
      'mascotasIds': FieldValue.arrayUnion([mascota.id])
    });
    
    await batch.commit();
  }
  
  Future<List<Mascota>> obtenerMascotas(String personaId) async {
    final snapshot = await _firestore
        .collection(mascotasCollection)
        .where('duenioId', isEqualTo: personaId)
        .get();

    return snapshot.docs.map((doc) => Mascota.fromMap(doc.id, doc.data())).toList();
  }
  // Con stream para obtener las mascotas de la persona
  Stream<List<Mascota>> streamMascotas(String personaId) {
    return _firestore
        .collection(mascotasCollection)
        .where('duenioId', isEqualTo: personaId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Mascota.fromMap(doc.id, doc.data()))
            .toList());
  }
  // Con listas 
  Future<List<Mascota>> obtenerMascotasDePersona(String personaUid) async {
    final query = await _firestore
        .collection(mascotasCollection)
        .where('duenioId', isEqualTo: personaUid)
        .get();
    
    return query.docs
        .map((doc) => Mascota.fromMap(doc.id, doc.data()))
        .toList();
  }
}