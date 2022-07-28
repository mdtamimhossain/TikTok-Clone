import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/comment.dart';
import 'package:intl/intl.dart';

class CommentsController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(firestore
        .collection('videos')
        .doc(_postId)
        .collection("comments")
        .snapshots()
        .map((QuerySnapshot query) {
      List<Comment> retVal = [];
      for (var element in query.docs) {
        retVal.add(Comment.fromSnap(element));
      }
      return retVal;
    }));
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot doc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection("comments")
            .get();
        int length = allDocs.docs.length;
        Comment comment = Comment(
            username: (doc.data()! as Map<String, dynamic>)['name'],
            comment: commentText.trim(),
            uid: authController.user.uid,
            publishDate: DateTime.now(),
            id: "comment${length}",
            likes: [],
            profilePhoto:
                (doc.data()! as Map<String, dynamic>)['profilePhoto']);
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc(comment.id)
            .set(
              comment.toJson(),
            );
        DocumentSnapshot docs =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount':
              (docs.data()! as Map<String, dynamic>)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar("Error while commenting ", e.toString());
    }
  }

  likeOnComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot docs = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();
    if ((docs.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
