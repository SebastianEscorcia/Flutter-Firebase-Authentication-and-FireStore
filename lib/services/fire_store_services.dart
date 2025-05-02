import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/peet.dart';
import '../data/models/person.dart';

class FirestoreService {
   FirebaseFirestore  get _firestore => FirebaseFirestore.instance;
 
  // Colecciones
  final String personasCollection = 'personas';
  final String mascotasCollection = 'mascotas';

  // Guardar persona
  Future<void> guardarPersona(Persona persona) async {
    await _firestore
        .collection(personasCollection)
        .doc(persona.uid)
        .set(persona.toMap());
  }

  // Obtener persona por UID
  Future<Persona?> obtenerPersona(String uid) async {
    final doc = await _firestore.collection(personasCollection).doc(uid).get();
    if (doc.exists) {
      return Persona.fromMap(uid, doc.data()!);
    }
    return null;
  }

  // Guardar mascota y actualizar referencia en persona
  Future<void> guardarMascota(Mascota mascota) async {
    final batch = _firestore.batch();
    
    // Guardar mascota
    final mascotaRef = _firestore.collection(mascotasCollection).doc(mascota.id);
    batch.set(mascotaRef, mascota.toMap());
    
    // Actualizar referencia en persona
    final personaRef = _firestore.collection(personasCollection).doc(mascota.duenioId);
    batch.update(personaRef, {
      'mascotasIds': FieldValue.arrayUnion([mascota.id])
    });
    
    await batch.commit();
  }

  // Obtener mascotas de una persona
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