import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(String childname, Uint8List file, bool isPost) async{
    Reference ref = await _storage.ref().child(childname).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid( ).v1();
      ref = ref.child(id);
    }
    UploadTask task = ref.putData(file);
    TaskSnapshot snap = await task;
    String url = await snap.ref.getDownloadURL();
    return url;
  }
}