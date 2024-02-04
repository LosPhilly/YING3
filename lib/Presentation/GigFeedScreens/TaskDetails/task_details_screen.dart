// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/user_profile_client_view_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';
import 'package:ying_3_3/providers/user_provider.dart';
import 'package:ying_3_3/resources/firestore_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';

import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/comments_widget.dart';

import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_outlined_button.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:ying_3_3/core/constants/persistant.dart';
import 'package:ying_3_3/widgets/like_button.dart';
import 'package:ying_3_3/widgets/share_button.dart';
import 'package:share_plus/share_plus.dart';

// ignore_for_file: must_be_immutable
class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String uploadedBy;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.uploadedBy,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class UserData {
  final String? name;

  UserData({this.name});
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

//JOB DETAILS VARIABLES//
  Timestamp? startDate;
  DateTime? startDateTime;
  String? startDateString;
  String? startDateTimeString;
  String? userDisplayName;

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  String? taskCategory;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimestamp;
  String? postedDated;
  int neededApplicants = 0;
  int neededApplicantsMax = 0;

  String? locationCompany = '';
  String? emailCompany = '';

  int applicants = 0;
  int maxApplicants = 0;
  List commentsPosted = [];
  List likes = [];
  bool isDeadlineAvailable = false;
  bool _isCommenting = false;
  bool showComment = false;
  bool canApply = true;

  bool showAlreadyParticipating = false;

  final TextEditingController _commentController = TextEditingController();
  List<String> buttonList = [];
  List<List> buttonIndex = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;
  List skills = [];

//JOB DETAILS VARIABLES//

// GET AND DISPLAY USER OR GROUP INFORMATION START //

  Future<void> getUserData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      var userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
      var userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        var userData = userDocSnapshot.data() as Map<String, dynamic>;

        var userName = userData['name'] as String?;

        if (userName != null) {
          setState(() {
            userDisplayName = userName;
          });
        }
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error getting User Menu document: $error');
    }
  }

// Create an onTap function that creates a popup that shows a set of instructions
  void showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'To get started create a task name, task description, choose your date and time, the location of the task and the number of people you will need.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showMaxParticipantsPopup(BuildContext context) {
    if (applicants == neededApplicants) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Max Participants Reached'),
            content: const Text(
                'Sorry but the max number of participants has been reached'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

// GET JOB DETAILS START//

  void getTaskData() async {
    final DocumentSnapshot taskDoc = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();

    // ignore: unnecessary_null_comparison
    if (taskDoc == null) {
      return;
    } else {
      setState(() {
        authorName = taskDoc.get('userName');
        userImageUrl = taskDoc.get('userImage');
      });
    }
    final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    // ignore: unnecessary_null_comparison
    if (taskDatabase == null) {
      return;
    } else {
      setState(() {
        jobTitle = taskDatabase.get('taskTitle');
        jobDescription = taskDatabase.get('taskDescription');
        recruitment = taskDatabase.get('recruitment');
        emailCompany = taskDatabase.get('email');
        locationCompany = taskDatabase.get('location');
        applicants = taskDatabase.get('applicants');
        postedDateTimeStamp = taskDatabase.get('createAt');
        deadlineDateTimestamp = taskDatabase.get('taskEndDate');
        neededApplicants = taskDatabase.get('applicantsNeeded');
        neededApplicantsMax = neededApplicants;
        likes = taskDatabase.get('likes');
        commentsPosted = taskDatabase.get('taskComments');
        taskCategory = taskDatabase.get('taskCategory');
        startDate = taskDatabase.get('taskStartDate');
        DateTime dateTime = startDate!.toDate();
        startDateTime = dateTime;
        String formattedTime = DateFormat('h:mm a').format(startDateTime!);
        String formattedDateTime =
            DateFormat('MMMM dd, yyyy').format(startDateTime!);
        startDateString = formattedDateTime;
        startDateTimeString = formattedTime;
        //dynamic skillsData = taskDatabase.get('skillsNeeded');
        //buttonIndex.add(taskDatabase.get('skillsNeeded'));
        print(formattedDateTime);
        skills = (taskDatabase.get("skillsNeeded") as List);

        isLiked = likes.contains(userDisplayName);

        /* if (skillsData is List<dynamic>) {
          buttonList = skillsData
              .map<String>((dynamic skillSet) => skillSet.toString())
              .toList();
        } */

        var postDate = postedDateTimeStamp!.toDate();

        postedDated =
            '${postDate.year} -- ${postDate.month} -- ${postDate.day}';
      });
      var date = deadlineDateTimestamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }

// Assuming taskDatabase is an instance of a Firestore database
    var applicantsList = taskDatabase.get('applicantsList');

    setState(() {
      canApply = !applicantsList.contains(userDisplayName);
    });
  }

//GET JOB DETAILS END//

  @override
  void initState() {
    super.initState();
    getTaskData();
    getUserData();
  }

  // Toggle Like
  void toggleLike() async {
    var docRef =
        FirebaseFirestore.instance.collection('tasks').doc(widget.taskId);
    await FirestoreMethods().storeNotification(
        _auth.currentUser!.uid, widget.taskId, 'like', widget.taskId);

    setState(() {
      isLiked = !isLiked;
    });
// Access the document in firebase
    if (isLiked) {
// if the post is now liked, add the user's name to the 'likes' field
      docRef.update({
        'likes': FieldValue.arrayUnion([userDisplayName])
      });
    } else {
      // remove the user from the 'likes' field
      docRef.update({
        'likes': FieldValue.arrayRemove([userDisplayName])
      });
    }
    getTaskData();
  }

  // Request Participation

  void requestParticipation() async {
    var docRef =
        FirebaseFirestore.instance.collection('tasks').doc(widget.taskId);
    await FirestoreMethods().storeNotification(
        _auth.currentUser!.uid, widget.taskId, 'participate', widget.taskId);

    getTaskData();
  }

// Add new applicants

  void addNewApplicant() async {
    if (applicants == neededApplicantsMax) {
      canApply = false;
      showMaxParticipantsPopup(context);
    } else {
      try {
        var docRef =
            FirebaseFirestore.instance.collection('tasks').doc(widget.taskId);

        // Use FieldValue.arrayUnion to add a new applicant to the array
        await docRef.update({
          'applicantsList': FieldValue.arrayUnion([userDisplayName]),
          'applicants':
              FieldValue.increment(1), // Increment the number of applicants
          // 'applicantsNeeded': FieldValue.increment(
          //   -1), // Decrement the number of needed applicants
        });

        // Fetch the updated task data
        getTaskData();
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          elevation: 8,
          context: context,
          constraints: BoxConstraints(maxHeight: 290.v),
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Center(
                child: Column(
                  children: [
                    CustomElevatedButton(
                      text: "Email Client",
                      isDisabled: false,
                      margin: EdgeInsets.only(left: 4.h, top: 5.v, right: 32.h),
                      leftIcon: Container(
                        margin: EdgeInsets.only(right: 8.h),
                        child: CustomImageView(
                          color: Colors.white,
                          svgPath: ImageConstant.imgMail,
                        ),
                      ),
                      buttonStyle: CustomButtonStyles.fillIndigoA,
                      onTap: () {},
                    ),
                    SizedBox(height: 5.v),
                    CustomElevatedButton(
                      text: "Message Client",
                      isDisabled: false,
                      margin: EdgeInsets.only(left: 4.h, top: 5.v, right: 32.h),
                      leftIcon: Container(
                        margin: EdgeInsets.only(right: 8.h),
                        child: CustomImageView(
                          color: Colors.white,
                          svgPath:
                              ImageConstant.imgOutlineChatTextPrimarycontainer,
                        ),
                      ),
                      buttonStyle: CustomButtonStyles.fillIndigoA,
                      onTap: () {},
                    ),
                    SizedBox(height: 5.v),
                    CustomElevatedButton(
                      text: "Call Client",
                      isDisabled: false,
                      margin: EdgeInsets.only(left: 4.h, top: 5.v, right: 32.h),
                      leftIcon: Container(
                        margin: EdgeInsets.only(right: 8.h),
                        child: CustomImageView(
                          color: Colors.white,
                          svgPath:
                              ImageConstant.imgOutlinephonePrimarycontainer,
                        ),
                      ),
                      buttonStyle: CustomButtonStyles.fillIndigoA,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (error) {
        print("Error adding applicant: $error");
      }
    }
  }

  void deleteApplicant() async {
    try {
      var docRef =
          FirebaseFirestore.instance.collection('tasks').doc(widget.taskId);

      // Use FieldValue.arrayRemove to delete a user from the array
      await docRef.update({
        'applicantsList': FieldValue.arrayRemove([userDisplayName]),
        'applicants':
            FieldValue.increment(-1), // Decrement the number of applicants
        //'applicantsNeeded': FieldValue.increment(
        //  1), // Increment the number of needed applicants
      });

      // Fetch the updated task data if needed
      getTaskData();
    } catch (error) {
      print('Error deleting applicant: $error');
    }
  }

// Add new applicants

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50, // Adjust the height to your preference
        backgroundColor: theme.colorScheme.primary,
        elevation: 8,
        leading: Align(
          alignment:
              Alignment.bottomLeft, // Align the leading icon to the bottom
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        title: Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: Text(
                jobTitle?.toString() ?? '',
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 25.0, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
            bottomRight: Radius.circular(20.0),
          ),
        ),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(height: 5.v),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 28.h, bottom: 28.v),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*  Text(jobTitle?.toString() ?? '',
                          style: theme.textTheme.titleLarge), */
                      SizedBox(height: 5.v),
                      Row(children: [
                        Row(
                          children: [
                            // Like button
                            LikeButton(isLiked: isLiked, onTap: toggleLike),
                            SizedBox(width: 2),

                            // like count
                            Text(likes.length.toString(),
                                style: CustomTextStyles.bodyMediumOnPrimary)
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showComment = !showComment;
                            });
                          },
                          child: CustomImageView(
                              svgPath: ImageConstant.imgOutlinechatfilled,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.only(left: 20.h)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 8.h),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showComment = !showComment;
                                });
                              },
                              child: Text(
                                  commentsPosted.isNotEmpty
                                      ? commentsPosted.length.toString()
                                      : "0",
                                  style: CustomTextStyles.bodyMediumOnPrimary),
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: ShareButton(
                              title: 'Share this task',
                              onPressed: () {
                                Share.share(jobTitle! +
                                    '\n' +
                                    'https://liveying.com/${widget.taskId}');
                              }),
                        ),
                      ]),
                      SizedBox(height: 20.v),
                      SizedBox(
                        height: 310.v,
                        width: 347.h,
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 324.v,
                                width: 305.h,
                                margin: EdgeInsets.only(bottom: 105.v),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CustomImageView(
                                        imagePath:
                                            ImageConstant.imgObject324x305,
                                        height: 324.v,
                                        width: 305.h,
                                        alignment: Alignment.center),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                height: 235.v,
                                width: 319.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          showDragHandle: true,
                                          elevation: 8,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.8, // Set a height constraint
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        const Text(
                                                          "Task Description",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const Divider(
                                                            thickness: 1),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 852,
                                                            child: Text(
                                                              jobDescription
                                                                      ?.toString() ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: CustomImageView(
                                          imagePath: ImageConstant
                                              .imgRectangle513200x319,
                                          height: 235.v,
                                          width: 319.h,
                                          radius: BorderRadius.circular(16.h),
                                          alignment: Alignment.center),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  showDragHandle: true,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return UserProfileClientViewScreen(
                                                        userId:
                                                            widget.uploadedBy);
                                                  },
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundImage: userImageUrl ==
                                                        null
                                                    ? const NetworkImage(
                                                        'https://www.iconpacks.net/icons/3/free-purple-person-icon-10780-thumb.png')
                                                    : NetworkImage(
                                                        userImageUrl!),
                                              ),
                                            ),
                                            Text(
                                                'by ${authorName ?? 'Unknown'}',
                                                style: CustomTextStyles
                                                    .titleSmallPrimaryContainer_3),
                                            SizedBox(height: 1.v),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  showDragHandle: true,
                                                  elevation: 8,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.8, // Set a height constraint
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                const Text(
                                                                  "Gig Description",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                    thickness:
                                                                        1),
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 852,
                                                                    child: Text(
                                                                      jobDescription
                                                                              ?.toString() ??
                                                                          '',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: SizedBox(
                                                width: 297.h,
                                                child: Text(
                                                  jobDescription?.toString() ??
                                                      '',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: CustomTextStyles
                                                      .bodySmallPrimaryContainer
                                                      .copyWith(height: 1.70),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 11.v),
                                            OutlineGradientButton(
                                              padding: EdgeInsets.only(
                                                  left: 3.h,
                                                  top: 3.v,
                                                  right: 3.h,
                                                  bottom: 3.v),
                                              strokeWidth: 3.h,
                                              gradient: LinearGradient(
                                                  begin:
                                                      const Alignment(0.5, 0),
                                                  end: const Alignment(0.5, 1),
                                                  colors: [
                                                    appTheme.cyan700
                                                        .withOpacity(0.5),
                                                    appTheme.green40001
                                                        .withOpacity(0.5)
                                                  ]),
                                              corners: const Corners(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8)),
                                              child: CustomOutlinedButton(
                                                height: 34.v,
                                                width: 221.h,
                                                text: "Contact",
                                                rightIcon: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 8.h),
                                                    child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineRightarrow)),
                                                leftIcon: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8.h),
                                                    child: CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineChatTextPrimarycontainer)),
                                                buttonStyle:
                                                    CustomButtonStyles.none,
                                                decoration: CustomButtonStyles
                                                    .gradientCyanToGreenTL8Decoration,
                                                buttonTextStyle: CustomTextStyles
                                                    .labelLargePrimaryContainer,
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    showDragHandle: true,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                    elevation: 8,
                                                    context: context,
                                                    constraints: BoxConstraints(
                                                        maxHeight: 290.v),
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 35,
                                                          ),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                CustomElevatedButton(
                                                                    text:
                                                                        "Email Client",
                                                                    isDisabled:
                                                                        false,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            4.h,
                                                                        top:
                                                                            5.v,
                                                                        right: 32
                                                                            .h),
                                                                    leftIcon: Container(
                                                                        margin: EdgeInsets.only(
                                                                            right: 8
                                                                                .h),
                                                                        child: CustomImageView(
                                                                            color: Colors
                                                                                .white,
                                                                            svgPath: ImageConstant
                                                                                .imgMail)),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .fillIndigoA,
                                                                    onTap:
                                                                        () {}),
                                                                SizedBox(
                                                                    height:
                                                                        5.v),
                                                                CustomElevatedButton(
                                                                    text:
                                                                        "Message Client",
                                                                    isDisabled:
                                                                        false,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            4.h,
                                                                        top:
                                                                            5.v,
                                                                        right: 32
                                                                            .h),
                                                                    leftIcon: Container(
                                                                        margin: EdgeInsets.only(
                                                                            right: 8
                                                                                .h),
                                                                        child: CustomImageView(
                                                                            color: Colors
                                                                                .white,
                                                                            svgPath: ImageConstant
                                                                                .imgOutlineChatTextPrimarycontainer)),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .fillIndigoA,
                                                                    onTap:
                                                                        () {}),
                                                                SizedBox(
                                                                    height:
                                                                        5.v),
                                                                CustomElevatedButton(
                                                                    text:
                                                                        "Call Client",
                                                                    isDisabled:
                                                                        false,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            4.h,
                                                                        top:
                                                                            5.v,
                                                                        right: 32
                                                                            .h),
                                                                    leftIcon: Container(
                                                                        margin: EdgeInsets.only(
                                                                            right: 8
                                                                                .h),
                                                                        child: CustomImageView(
                                                                            color: Colors
                                                                                .white,
                                                                            svgPath: ImageConstant
                                                                                .imgOutlinephonePrimarycontainer)),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .fillIndigoA,
                                                                    onTap:
                                                                        () {}),
                                                              ],
                                                            ),
                                                          ));
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          FirebaseAuth.instance.currentUser!.uid !=
                                  widget.uploadedBy
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(thickness: 1),
                                    const Text(
                                      'Recruitment',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('tasks')
                                                    .doc(widget.taskId)
                                                    .update(
                                                        {'recruitment': true});
                                              } catch (error) {
                                                GlobalMethod.showErrorDialog(
                                                  error:
                                                      'Action cannot be preformed',
                                                  ctx: context,
                                                );
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                error:
                                                    'You cannot preform this action',
                                                ctx: context,
                                              );
                                            }
                                            getTaskData();
                                          },
                                          child: const Text(
                                            'ON',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: recruitment == true ? 1 : 0,
                                          child: const Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Opacity(
                                          opacity: recruitment == false ? 1 : 0,
                                          child: const Icon(
                                            Icons.check_box,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('tasks')
                                                    .doc(widget.taskId)
                                                    .update(
                                                        {'recruitment': false});
                                              } catch (error) {
                                                GlobalMethod.showErrorDialog(
                                                  error:
                                                      'Action cannot be preformed',
                                                  ctx: context,
                                                );
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                error:
                                                    'You cannot preform this action',
                                                ctx: context,
                                              );
                                            }
                                            getTaskData();
                                          },
                                          child: const Text(
                                            'OFF',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("More Details",
                                  style: theme.textTheme.titleLarge),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Skills Needed:',
                                      style: theme.textTheme.titleSmall),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: skills.isEmpty ? 0 : 47.v),
                                      skills.isEmpty
                                          ? Text("No Skills Declared",
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                      fontFamily: 'Poppins'))
                                          : const SizedBox(),
                                      SizedBox(height: 16.v),
                                      Wrap(
                                        runSpacing: 5.0,
                                        spacing: 8.0,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        clipBehavior: Clip.hardEdge,
                                        children: [
                                          for (var i in skills)
                                            UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 12,
                                              gradient: LinearGradient(
                                                colors: [
                                                  appTheme.purple50,
                                                  appTheme.purple400
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              onPressed: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 16),
                                                child: Text(
                                                  i.toString(),
                                                  style: theme
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: appTheme.black900,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 47.v),
                                    ],
                                    //SizedBox(height: 16.v),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 65.v),
                          Padding(
                            padding: const EdgeInsets.only(top: 45),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Gig Details:',
                                      style: theme.textTheme.titleSmall),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 35, bottom: 10.v, top: 5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.h, vertical: 23.v),
                                    decoration: AppDecoration.outlineOnPrimary
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconButton(
                                            height: 48.adaptSize,
                                            width: 48.adaptSize,
                                            padding: EdgeInsets.all(12.h),
                                            decoration: IconButtonStyleHelper
                                                .fillOrangeTL24,
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgIcsharpeventnote)),
                                        SizedBox(height: 9.v),
                                        Text(taskCategory ?? "Unknown",
                                            style: theme.textTheme.titleSmall),
                                        SizedBox(height: 3.v),
                                        Text(
                                            neededApplicants <= 1
                                                ? "$neededApplicants person needed"
                                                : "$neededApplicants people needed",
                                            style: CustomTextStyles
                                                .bodySmallOnPrimary_1)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(right: 35.v),
                              padding: EdgeInsets.all(24.h),
                              decoration: AppDecoration.outlineOnPrimary
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconButton(
                                    height: 48.adaptSize,
                                    width: 48.adaptSize,
                                    padding: EdgeInsets.all(12.h),
                                    decoration:
                                        IconButtonStyleHelper.fillPurple,
                                    child: CustomImageView(
                                        svgPath:
                                            ImageConstant.imgAkariconslocation),
                                  ),
                                  SizedBox(height: 9.v),
                                  Text(
                                    locationCompany!,
                                    style: theme.textTheme.titleSmall,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin:
                                  EdgeInsets.only(right: 20.h, bottom: 25.v),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.h, vertical: 23.v),
                              decoration: AppDecoration.outlineOnPrimary
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconButton(
                                      height: 48.adaptSize,
                                      width: 48.adaptSize,
                                      padding: EdgeInsets.all(12.h),
                                      decoration: IconButtonStyleHelper
                                          .fillLightBlueTL24,
                                      child: CustomImageView(
                                          svgPath: ImageConstant.imgBxtime)),
                                  SizedBox(height: 9.v),
                                  Text(startDateTimeString ?? "time",
                                      style: theme.textTheme.titleSmall),
                                  SizedBox(height: 3.v),
                                  Text(startDateString ?? "date",
                                      style:
                                          CustomTextStyles.bodySmallOnPrimary_1)
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 5.h, bottom: 25.v),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 21.h, vertical: 24.v),
                              decoration: AppDecoration.outlineOnPrimary
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconButton(
                                    height: 48.adaptSize,
                                    width: 48.adaptSize,
                                    padding: EdgeInsets.all(12.h),
                                    decoration:
                                        IconButtonStyleHelper.fillGreenTL24,
                                    child: CustomImageView(
                                        svgPath: ImageConstant
                                            .imgAntdesignteamoutlined),
                                  ),
                                  SizedBox(height: 10.v),
                                  Text("$applicants",
                                      style: theme.textTheme.titleSmall),
                                  SizedBox(height: 2.v),
                                  Text(
                                      applicants == 1
                                          ? "Participant"
                                          : applicants == 0
                                              ? "Participants"
                                              : "Participants",
                                      style:
                                          CustomTextStyles.bodySmallOnPrimary_1)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      canApply
                          ? CustomElevatedButton(
                              text: "Request Participation",
                              margin: EdgeInsets.only(
                                  left: 4.h, top: 5.v, right: 32.h),
                              leftIcon: Container(
                                margin: EdgeInsets.only(right: 8.h),
                                child: CustomImageView(
                                  svgPath: ImageConstant
                                      .imgOutlineaddPrimarycontainer,
                                ),
                              ),
                              buttonStyle: CustomButtonStyles.fillIndigoA,
                              onTap: () {
                                addNewApplicant();
                                requestParticipation();
                              },
                            )
                          : Column(
                              children: [
                                CustomElevatedButton(
                                  text: "You are already Participating",
                                  isDisabled:
                                      showAlreadyParticipating ? false : true,
                                  margin: EdgeInsets.only(
                                      left: 4.h, top: 5.v, right: 32.h),
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 8.h),
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgCheckmark,
                                    ),
                                  ),
                                  buttonStyle: CustomButtonStyles.fillIndigoA,
                                  onTap: () {},
                                ),
                                const SizedBox(),
                                CustomElevatedButton(
                                  text: "Cancel Participation",
                                  isDisabled: false,
                                  margin: EdgeInsets.only(
                                      left: 4.h, top: 5.v, right: 32.h),
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 8.h),
                                    child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineclose,
                                    ),
                                  ),
                                  buttonStyle: CustomButtonStyles.fillIndigoA,
                                  onTap: () {
                                    deleteApplicant();
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0), // Top left corner radius
                    topRight: Radius.circular(30.0), // Top right corner radius
                    bottomLeft:
                        Radius.circular(30.0), // Bottom left corner radius
                    bottomRight:
                        Radius.circular(30.0), // Bottom right corner radius
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft:
                            Radius.circular(30.0), // Top left corner radius
                        topRight:
                            Radius.circular(30.0), // Top right corner radius
                        bottomLeft:
                            Radius.circular(30.0), // Bottom left corner radius
                        bottomRight:
                            Radius.circular(30.0), // Bottom right corner radius
                      ),
                      child: Card(
                        color: theme.colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: _isCommenting
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              flex: 3,
                                              child: TextField(
                                                controller: _commentController,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                maxLength: 200,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 6,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Colors.white,
                                                    )),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .pink))),
                                              )),
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                  ),
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      if (_commentController
                                                              .text.length <
                                                          7) {
                                                        GlobalMethod
                                                            .showErrorDialog(
                                                                error:
                                                                    'Comment Cannot be less than 7 characters',
                                                                ctx: context);
                                                      } else {
                                                        final _generatedId =
                                                            const Uuid().v4();
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('tasks')
                                                            .doc(widget.taskId)
                                                            .update({
                                                          'taskComments':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            {
                                                              'userId':
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid,
                                                              'commentId':
                                                                  _generatedId,
                                                              'name':
                                                                  userDisplayName,
                                                              'userImageUrl':
                                                                  userImage,
                                                              'commentBody':
                                                                  _commentController
                                                                      .text,
                                                              'time': Timestamp
                                                                  .now(),
                                                            }
                                                          ])
                                                        });

                                                        await Fluttertoast
                                                            .showToast(
                                                          msg:
                                                              'Your comment has been added',
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          fontSize: 18,
                                                        );
                                                        setState(() {
                                                          _isCommenting = false;
                                                        });
                                                        _commentController
                                                            .clear();
                                                        getTaskData();
                                                      }
                                                    },
                                                    color: theme.colorScheme
                                                        .onSecondary,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Text(
                                                      'Post',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isCommenting =
                                                          !_isCommenting;
                                                      showComment = false;
                                                    });
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showComment =
                                                          !showComment;
                                                      _isCommenting = false;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_circle,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isCommenting =
                                                      !_isCommenting;
                                                  showComment = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add_comment,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showComment = !showComment;
                                                  _isCommenting = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              showComment == false
                                  ? Container()
                                  : SingleChildScrollView(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child:
                                              FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(widget.taskId)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data![
                                                          'taskComments'] ==
                                                      null) {
                                                return const Center(
                                                  child: Text(
                                                      'No Comments for this task'),
                                                );
                                              }

                                              // Get the list of comments
                                              List<dynamic> comments = snapshot
                                                  .data!['taskComments'];

                                              // Sort the comments by the 'time' field in descending order
                                              comments.sort((a, b) => b['time']
                                                  .compareTo(a['time']));

                                              return ListView.separated(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var commentDate =
                                                      comments[index]['time'];

                                                  DateTime commentDateString =
                                                      commentDate.toDate();

                                                  // Format the DateTime to a relative time string
                                                  String timeAgo =
                                                      timeago.format(
                                                    commentDateString,
                                                    locale: 'en_long',
                                                  );

                                                  return CommentWidget(
                                                    commentTime: timeAgo,
                                                    commentId: comments[index]
                                                        ['commentId'],
                                                    commenterId: comments[index]
                                                        ['userId'],
                                                    commenterName:
                                                        comments[index]['name'],
                                                    commentBody: comments[index]
                                                        ['commentBody'],
                                                    commenterImageUrl:
                                                        comments[index]
                                                            ['userImageUrl'],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider(
                                                    thickness: 1,
                                                    color: Colors.grey,
                                                  );
                                                },
                                                itemCount: comments.length,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the chatRoomOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the chatRoomOneScreen.
  onTapMessage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the gigFeed3TaskDetailsConfirmationScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed3TaskDetailsConfirmationScreen.
  onTapRequest(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;

  UnicornOutlineButton({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required VoidCallback onPressed,
  })  : this._painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._callback = onPressed,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            constraints: BoxConstraints(minWidth: 88, minHeight: 38),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.primary.withOpacity(.30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
      required double radius,
      required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
