import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatelessWidget {
  final String id;
  final TextEditingController _commentsController = TextEditingController();
  CommentsController commentsController = Get.put(CommentsController());
  CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    commentsController.updatePostId(id);
    return Scaffold(
      body: SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: commentsController.comments.length,
                itemBuilder: (context, index) {
                  final commet = commentsController.comments[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(commet.profilePhoto),
                    ),
                    title: Row(
                      children: [
                        Text(
                          commet.username,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          commet.comment,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          timeago.format(DateTime.now()),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${commet.likes.length} likes",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        return commentsController.likeOnComment(commet.id);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: commet.likes.contains(commet.uid)
                            ? Colors.red
                            : Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const Divider(),
          ListTile(
            title: TextFormField(
              controller: _commentsController,
              style: const TextStyle(fontSize: 17, color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Comment",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                commentsController.postComment(_commentsController.text);
              },
              child: const Text(
                "Send",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]),
      )),
    );
  }
}
