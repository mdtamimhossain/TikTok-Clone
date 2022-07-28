import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comment {
  String username;
  String comment;
  String uid;
  String id;
  List likes;
  final publishDate;
  String profilePhoto;
  Comment(
      {required this.username,
      required this.comment,
      required this.uid,
      required this.id,
      required this.likes,
      required this.profilePhoto,
      required this.publishDate});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'comment': comment,
      'uid': uid,
      'id': id,
      'likes': likes,
      'profilePhoto': profilePhoto,
    };
  }

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
        username: snapshot['username'],
        comment: snapshot['comment'],
        publishDate: snapshot["publishDate"],
        uid: snapshot['uid'],
        id: snapshot['id'],
        likes: snapshot['likes'],
        profilePhoto: snapshot['profilePhoto']);
  }
}
