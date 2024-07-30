import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> uploadPost(String descripton, Uint8List file , String uid, String username, String profimage) async{
    String res ='some error occured';
    try{
      String photourl = await StorageMethods().uploadImageToStorage('Posts', file, true);
      String postId =const Uuid().v1();
      Post post = Post(descripton: descripton, uid: uid, username: username, postId: postId, datePublished: DateTime.now(), postUrl: photourl, profimage: profimage, likes: []);
      _firestore.collection('posts').doc(postId).set(post.tojson());
      res = 'success'; 

    }catch(e){
      res = e.toString();
    }
    return res;
  }



  Future<void> likePost(String postId, String uid, List likes ) async{
  try{
    if(likes.contains(uid)){
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    }
    else{
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
    
  }catch(e){
    print(e);
  }
 }


 Future<void> postComment(String postid, String text, String uid, String name, String profimage) async{

  try{
    if(text.isNotEmpty){
      String commentid = const Uuid().v1();
      await _firestore.collection('posts').doc(postid).collection('comments').doc(commentid).set({
        'profilepic' : profimage,
        'name' : name,
        'uid' : uid,
        'text' : text,
        'commentid' : commentid,
        'datepublished': DateTime.now()
      });
    }else{
      print('text is empty');
    }


  }catch(e){

  }

 }

  Future<void> deletepost(String postid)async{
    try{
      await _firestore.collection('posts').doc(postid).delete();
    }catch(e){}
  }


  Future<void> followuser(String uid, String followId) async{
    try{}catch(e){
      DocumentSnapshot snap =  await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId])
        });
      }
      else {
        await _firestore.collection('users').doc(followId).update({
          'followers' : FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId])
        });
      }


    }
  } 

 }


 