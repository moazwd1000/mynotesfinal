import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotesfinal/services/cloud/cloud_note.dart';
import 'package:mynotesfinal/services/cloud/cloud_storage_constants.dart';
import 'package:mynotesfinal/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloud {
  static final FirebaseCloud _shared = FirebaseCloud._sharedInstance();
  FirebaseCloud._sharedInstance();
  factory FirebaseCloud() => _shared;

  final notes = FirebaseFirestore.instance.collection("notes");

  void createNewNote({required String ownerUserId}) async {
    await notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: " "});
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                    documentId: doc.id,
                    text: doc.data()[textFieldName] as String,
                    ownerUserId: doc.data()[ownerUserIdFieldName] as String);
              }));
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote(
      {required String text, required String documentId}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}
