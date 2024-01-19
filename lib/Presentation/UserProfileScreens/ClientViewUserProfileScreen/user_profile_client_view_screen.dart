import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/TaskDetails/task_details_screen.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/widgets/chipviewchips6_item_widget.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_outlined_button.dart';
import 'package:ying_3_3/widgets/custom_rating_bar.dart';

class UserProfileClientViewScreen extends StatefulWidget {
  final String userId;
  const UserProfileClientViewScreen({required this.userId});

  @override
  State<UserProfileClientViewScreen> createState() =>
      _UserProfileClientViewScreenState();
}

class _UserProfileClientViewScreenState
    extends State<UserProfileClientViewScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;
  bool isOnline = false;

  getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc == null) {
        return CircularProgressIndicator();
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          imageUrl = userDoc.get('userImage');
          isOnline = userDoc.get('isOnline');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt =
              '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
      // ignore: empty_catches
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 28.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.h, bottom: 122.v),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageUrl.isEmpty
                                    ? const CircularProgressIndicator()
                                    : CircleAvatar(
                                        radius: 55,
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),
                              ]),
                        ),
                        SizedBox(height: 17.v),
                        Text(name.toString(),
                            style: CustomTextStyles.titleMediumOnPrimaryBold),
                        SizedBox(height: 4.v),
                        Text("UX/UI Designer",
                            style: theme.textTheme.bodyMedium),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                              color: isOnline ? Colors.green : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 11.h, top: 52.v, right: 43.h),
                          child: Row(
                            children: [
                              Column(children: [
                                Text("Completed",
                                    style: theme.textTheme.bodyMedium),
                                SizedBox(height: 2.v),
                                RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "89 ",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimary18),
                                      TextSpan(
                                          text: "jobs",
                                          style: CustomTextStyles
                                              .bodySmallOnPrimary)
                                    ]),
                                    textAlign: TextAlign.left)
                              ]),
                              Padding(
                                padding: EdgeInsets.only(left: 31.h),
                                child: Column(
                                  children: [
                                    Text("In Progress",
                                        style: theme.textTheme.bodyMedium),
                                    SizedBox(height: 1.v),
                                    RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "5 ",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary18),
                                            TextSpan(
                                                text: "jobs",
                                                style: CustomTextStyles
                                                    .bodySmallOnPrimary)
                                          ],
                                        ),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30.h),
                                child: Column(
                                  children: [
                                    Text("Experience",
                                        style: theme.textTheme.bodyMedium),
                                    SizedBox(height: 2.v),
                                    RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "4.5 ",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary18),
                                            TextSpan(
                                                text: "years",
                                                style: CustomTextStyles
                                                    .bodySmallOnPrimary)
                                          ],
                                        ),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        CustomElevatedButton(
                            height: 40.v,
                            text: "Message ${name.toString()}",
                            margin: EdgeInsets.only(
                                left: 4.h, top: 16.v, right: 32.h),
                            rightIcon: Container(
                              margin: EdgeInsets.only(left: 8.h),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgOutlineRightarrow),
                            ),
                            leftIcon: Container(
                                margin: EdgeInsets.only(right: 8.h),
                                child: CustomImageView(
                                    svgPath: ImageConstant
                                        .imgOutlineChatTextPrimarycontainer)),
                            buttonStyle: CustomButtonStyles.fillPrimaryTL8,
                            buttonTextStyle:
                                CustomTextStyles.titleSmallPrimaryContainer_3,
                            onTap: () {
                              onTapMessagejoshua(context);
                            }),
                        SizedBox(height: 47.v),
                        Text("Skills", style: theme.textTheme.titleLarge),
                        SizedBox(height: 16.v),
                        Wrap(
                          runSpacing: 14.v,
                          spacing: 14.h,
                          children: List<Widget>.generate(
                            8,
                            (index) => const Chipviewchips6ItemWidget(),
                          ),
                        ),
                        SizedBox(height: 47.v),
                        Text("Reviews", style: theme.textTheme.titleLarge),
                        SizedBox(height: 16.v),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant
                                            .imgLizhangkdwbstxliyunsplash,
                                        height: 148.v,
                                        width: 152.h,
                                        radius: BorderRadius.circular(16.h)),
                                    SizedBox(height: 13.v),
                                    Text("Project Name",
                                        style: CustomTextStyles
                                            .titleMediumOnPrimary),
                                    SizedBox(height: 3.v),
                                    SizedBox(
                                      width: 150.h,
                                      child: Text(
                                        "Extremely satisfied with the skills Joshua showed!",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles
                                            .bodySmallOnPrimary_1
                                            .copyWith(height: 1.70),
                                      ),
                                    ),
                                    SizedBox(height: 10.v),
                                    CustomRatingBar(initialRating: 0)
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgDimgungerokn1,
                                        height: 148.v,
                                        width: 152.h,
                                        radius: BorderRadius.circular(16.h),
                                      ),
                                      SizedBox(height: 13.v),
                                      Text("Project Name",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimary),
                                      SizedBox(height: 3.v),
                                      SizedBox(
                                        width: 150.h,
                                        child: Text(
                                          "Extremely satisfied with the skills Joshua showed!",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .bodySmallOnPrimary_1
                                              .copyWith(height: 1.70),
                                        ),
                                      ),
                                      SizedBox(height: 10.v),
                                      CustomRatingBar(initialRating: 0)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgSimonleexx5rq,
                                        height: 148.v,
                                        width: 152.h,
                                        radius: BorderRadius.circular(16.h),
                                      ),
                                      SizedBox(height: 13.v),
                                      Text("Project Name",
                                          style: CustomTextStyles
                                              .titleMediumOnPrimary),
                                      SizedBox(height: 3.v),
                                      SizedBox(
                                        width: 152.h,
                                        child: Text(
                                          "Extremely satisfied with the skills Joshua showed!",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .bodySmallOnPrimary_1
                                              .copyWith(height: 1.70),
                                        ),
                                      ),
                                      SizedBox(height: 10.v),
                                      Row(
                                        children: [
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgOutlinestarfilled,
                                              height: 12.adaptSize,
                                              width: 12.adaptSize),
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgOutlinestarfilled,
                                              height: 12.adaptSize,
                                              width: 12.adaptSize),
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgOutlinestarfilled,
                                              height: 12.adaptSize,
                                              width: 12.adaptSize),
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgOutlinestarfilled,
                                              height: 12.adaptSize,
                                              width: 12.adaptSize),
                                          CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgOutlinestarBlueGray200,
                                              height: 12.adaptSize,
                                              width: 12.adaptSize)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the userProfileMessageJoshuaScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileMessageJoshuaScreen.
  onTapMessagejoshua(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
