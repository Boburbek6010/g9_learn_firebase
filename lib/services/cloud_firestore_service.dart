import 'package:cloud_firestore/cloud_firestore.dart';

class CFSService{

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<DocumentReference<Map<String, dynamic>>> createCollection({required String collectionPath, required Map<String, dynamic> data})async{
    DocumentReference<Map<String, dynamic>> documentReference = await db.collection(collectionPath).add(data);
    return documentReference;
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> readAllData({required String collectionPath})async{
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
    await db.collection(collectionPath).get().then((value) {
      for(var doc in value.docs){
        documents.add(doc);
      }
    });
    return documents;
  }


  static Future<void> delete({required String collectionPath, required String id})async{
    await db.collection(collectionPath).doc(id).delete();
  }

  static Future<void> update({required String collectionPath, required String id, required Map<String, dynamic> data})async{
    await db.collection(collectionPath).doc(id).update(data);
  }



}