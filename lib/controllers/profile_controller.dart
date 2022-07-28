import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value.obs;
  Rx<String> _uid = ''.obs;
  updateUserUid(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thambnail = [];
    var allVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < allVideos.docs.length; i++) {
      thambnail.add((allVideos.docs[i].data() as dynamic)['thumbnails']);
    }
    DocumentSnapshot userDocument =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = userDocument.data()! as dynamic;
    int likes = 0;
    int followers = 0;
    int following = 0;
    String userName = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    bool isFollowing = false;

    for (var item in allVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    final followersDocument = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    final followingDocument = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followersDocument.docs.length;
    following = followingDocument.docs.length;
    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user.value = {
      "followers": followers.toString(),
      "following": following.toString(),
      "likes": likes.toString(),
      'profilePhoto': profilePhoto,
      "isFollowing": isFollowing,
      "thumbnails": thambnail,
      "name": userName
    };
  }

  followUser() async {
    var document = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get();
    if (!document.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('following')
          .doc(authController.user.uid)
          .set({});
      _user.value.update('followers', (value) {
        return (int.parse(value) + 1).toString();
      });
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user.uid)
          .delete();
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('following')
          .doc(authController.user.uid)
          .delete();
      _user.value.update('followers', (value) {
        return (int.parse(value) - 1).toString();
      });
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
