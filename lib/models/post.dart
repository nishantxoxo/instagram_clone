import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String descripton;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  
  final String postUrl;
  final String profimage;
  final likes;

  const Post(
      {required this.descripton,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profimage,
      required this.likes});

  Map<String, dynamic> tojson() => {
        "description": descripton,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profimage": profimage,
        "likes": likes
      };

  static Post fromsnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      descripton: snap['description'],
      uid: snap['uid'],
      username: snap['username'], 
      postId: snap['postId'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      profimage: snap['profimage'],
      likes: snap['likes']
    );
  }
}
