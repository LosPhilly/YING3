import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ying_3_3/core/constants/string_const.dart';
import 'package:ying_3_3/core/utils/helper_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/global_methods.dart';
import '../../../../theme/theme_helper.dart';
import '../../TaskDetails/task_details_screen.dart';

class GigFeedListTile extends StatefulWidget {
  const GigFeedListTile({
    Key? key,
    required this.userImage,
    required this.taskName,
    required this.taskDescription,
    required this.uploadBy,
    required this.jobID,
    required this.taskImages,
    required this.createAt,
  }) : super(key: key);

  final String userImage;
  final String taskName;
  final String taskDescription;
  final String uploadBy;
  final String jobID;
  final Timestamp createAt;
  final List<String> taskImages;

  @override
  State<GigFeedListTile> createState() => _GigFeedListTileState();
}

class _GigFeedListTileState extends State<GigFeedListTile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(
              taskId: widget.jobID,
              uploadedBy: widget.uploadBy,
            ),
          ),
        );
      },
      onLongPress: () {
        _deleteDialog();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.userImage),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.taskName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: REGULAR_FONT,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(
                      widget.taskDescription,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        timeago.format(widget.createAt.toDate()),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
          HelperUtils.verticalSpace(6),
          SizedBox(
            height: 190,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: (widget.taskImages.isEmpty
                        ? [
                            'https://images.pexels.com/photos/2035066/pexels-photo-2035066.jpeg?auto=compress&cs=tinysrgb&w=600',
                            'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=600',
                            "https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                            'https://images.pexels.com/photos/866021/pexels-photo-866021.jpeg?auto=compress&cs=tinysrgb&w=600',
                            "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                            "https://cdn.dummyjson.com/product-images/24/thumbnail.jpg"
                          ]
                        : widget.taskImages)
                    .map((img) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, right: 8, left: 1.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 80,
                        height: MediaQuery.of(context).size.height - 1,
                      ),
                    ),
                  );
                }).toList()),
          ),
          HelperUtils.verticalSpace(10)
        ],
      ),
    );
  }

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
                      if (widget.uploadBy == _uid) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.jobID)
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
}
