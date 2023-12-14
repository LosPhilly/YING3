import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ying_3_3/Presentation/GigFeedScreens/TaskDetails/task_details_screen.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobCategory;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  final Color backgroundColor;

  const JobWidget({
    required this.jobTitle,
    required this.jobCategory,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
    required this.backgroundColor,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //DELETE USER POST START//
  void _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      if (widget.uploadedBy == _uid) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.jobId)
                            .delete();
                        await Fluttertoast.showToast(
                          msg: 'Job has been deleted',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.grey,
                          fontSize: 18,
                        );
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      } else {
                        GlobalMethod.showErrorDialog(
                          error: 'You cannot perform this action',
                          ctx: ctx,
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        GlobalMethod.showErrorDialog(
                          error: "Task cannot be deleted an error occured.",
                          ctx: ctx,
                        );
                      }
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //DELETE USER POST END//

  // Get Likes

  List<String> likesGotten = [];

  Future<List<String>?> getLikes() async {
    final DocumentSnapshot taskRef = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.jobId)
        .get();
    List<String> taskGet = taskRef['likes'];
    setState(() {
      likesGotten = taskGet;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(1),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // ignore: unnecessary_null_comparison
              builder: (context) => null == true
                  ? const CircularProgressIndicator()
                  : TaskDetailsScreen(
                      taskId: widget.jobId,
                      uploadedBy: widget.uploadedBy,
                    ),
            ),
          );
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        leading: Container(
          padding: const EdgeInsets.only(right: 2),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(widget.userImage),
          ),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color.fromARGB(255, 98, 54, 255),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: widget.backgroundColor.withOpacity(0.5)),
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              child: Text(
                widget.jobCategory,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Color.fromARGB(255, 98, 54, 255),
        ),
      ),
    );
  }
}
