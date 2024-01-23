import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ying_3_3/core/constants/color_map.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import 'package:flutter/material.dart';
import 'package:ying_3_3/widgets/job_widget.dart';

class MyGigSchedule extends StatefulWidget {
  const MyGigSchedule({Key? key}) : super(key: key);

  @override
  MyGigScheduleState createState() => MyGigScheduleState();
}

class MyGigScheduleState extends State<MyGigSchedule>
    with AutomaticKeepAliveClientMixin<MyGigSchedule> {
  String? jobCategoryFilter;
  final _auth = FirebaseAuth.instance;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.v);
                        },
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 550.v,
                            child: Stack(
                              children: [
                                StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  stream: _auth.currentUser!.uid == null
                                      ? FirebaseFirestore.instance
                                          .collection('tasks')
                                          .where('recruitment', isEqualTo: true)
                                          .orderBy('createAt', descending: true)
                                          .snapshots()
                                      : FirebaseFirestore.instance
                                          .collection('tasks')
                                          .where('uploadedBy',
                                              isEqualTo: _auth.currentUser!.uid)
                                          .where('recruitment', isEqualTo: true)
                                          .orderBy('createAt', descending: true)
                                          .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.docs.isNotEmpty) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 1.v),
                                            const Divider(thickness: 2),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Color backgroundColor =
                                                      categoryColors[snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .data()[
                                                              'taskCategory']] ??
                                                          Colors.grey;
                                                  return JobWidget(
                                                    jobTitle: snapshot
                                                            .data!.docs[index]
                                                        ['taskTitle'],
                                                    jobDescription: snapshot
                                                            .data!.docs[index]
                                                            .data()[
                                                        'taskDescription'],
                                                    jobId: snapshot
                                                        .data!.docs[index]
                                                        .data()['taskId'],
                                                    uploadedBy: snapshot
                                                        .data!.docs[index]
                                                        .data()['uploadedBy'],
                                                    createAt: snapshot
                                                        .data!.docs[index]
                                                        .data()['createAt'],
                                                    userImage: snapshot
                                                        .data!.docs[index]
                                                        .data()['userImage'],
                                                    name: snapshot
                                                        .data!.docs[index]
                                                        .data()['userName'],
                                                    recruitment: snapshot
                                                        .data!.docs[index]
                                                        .data()['recruitment'],
                                                    jobCategory: snapshot
                                                        .data!.docs[index]
                                                        .data()['taskCategory'],
                                                    email: snapshot
                                                        .data!.docs[index]
                                                        .data()['email'],
                                                    location: snapshot
                                                        .data!.docs[index]
                                                        .data()['location'],
                                                    backgroundColor:
                                                        backgroundColor,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                          child: Text(
                                              'There are no gigs available'),
                                        );
                                      }
                                    }
                                    return const Center(
                                      child: Text(
                                        'Something went wrong',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Navigates to the myCardsDebitCardAddDebitCardThreeScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the myCardsDebitCardAddDebitCardThreeScreen.
  onTapAdddebitcard(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
