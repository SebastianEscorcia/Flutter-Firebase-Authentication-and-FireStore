import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_and_firestore/data/models/person.dart';

class PersonaServices {
  final String personasCollection = 'personas';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> crearPersona(Persona persona) async {
    await _firestore
        .collection(personasCollection)
        .doc(persona.uid)
        .set(persona.toMap());
  }

  Future<void> actualizarPersona(Persona persona) async {
    try {
      await _firestore
          .collection('personas')
          .doc(persona.uid)
          .update(persona.toMap());
          //.set(persona.toMap(), SetOptions(merge: true));
    } catch (e) {
      print("🔥 Error actualizando persona: $e");
      rethrow;
    }
  }

  Future<Persona?> obtenerPersona(String uid) async {
    final doc = await _firestore.collection(personasCollection).doc(uid).get();
    if (doc.exists) {
      return Persona.fromMap(uid, doc.data()!);
    }
    return null;
  }

  Stream<Persona?> streamPersona(String uid) {
    return _firestore
        .collection('personas')
        .doc(uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.exists ? Persona.fromMap(uid, snapshot.data()!) : null,
        );
  }
}
