import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  int completed = 0;
  int inProgress = 0;
  int experience = 0;
  String jobname = '';
  bool _isLoading = false;
  bool _isSameUser = false;
  bool isOnline = false;

  List skills = [];

  getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc != null) {
        setState(() {});
        name = userDoc.get('name');
        imageUrl = userDoc.get('userImage') ?? '';
        isOnline = userDoc.get('isOnline');
        skills = (userDoc.get("skills") as List);
        completed = userDoc.get('completed');
        inProgress = userDoc.get('inProgress');
        experience = userDoc.get('experience');
        jobname = userDoc.get('jobname');
        Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
        var joinedDate = joinedAtTimeStamp.toDate();
        joinedAt =
            '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        setState(() {});
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
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageUrl.isEmpty
                                  ? const CircularProgressIndicator()
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(imageUrl),
                                    ),
                            ]),
                      ),
                      SizedBox(height: 17.v),
                      Center(
                        child: Text(name.toString(),
                            style: CustomTextStyles.titleMediumOnPrimaryBold),
                      ),
                      SizedBox(height: 5.v),
                      Center(
                        child: Text("UX/UI Designer",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontFamily: 'Poppins')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 52.v,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Text("Completed",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontFamily: 'Poppins')),
                              SizedBox(height: 2.v),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: completed.toString(),
                                        style: CustomTextStyles
                                            .titleMediumOnPrimary18),
                                    TextSpan(
                                        text: " jobs",
                                        style:
                                            CustomTextStyles.bodySmallOnPrimary)
                                  ]),
                                  textAlign: TextAlign.left)
                            ]),
                            Padding(
                              padding: EdgeInsets.only(left: 31.h),
                              child: Column(
                                children: [
                                  Text("In Progress",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontFamily: 'Poppins')),
                                  SizedBox(height: 1.v),
                                  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: inProgress.toString(),
                                              style: CustomTextStyles
                                                  .titleMediumOnPrimary18),
                                          TextSpan(
                                              text: " jobs",
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
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontFamily: 'Poppins')),
                                  SizedBox(height: 2.v),
                                  RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: experience.toString(),
                                              style: CustomTextStyles
                                                  .titleMediumOnPrimary18),
                                          TextSpan(
                                              text: " years",
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
                      SizedBox(height: 15.h),
                      CustomElevatedButton(
                          height: 40.v,
                          text: "Message ${name.toString()}",
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
                      SizedBox(height: skills.isNotEmpty ? 47.v : 0),
                      skills.isNotEmpty
                          ? Text("Skills",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontFamily: 'Poppins'))
                          : const SizedBox(),
                      SizedBox(height: 16.v),
                      Wrap(
                        runSpacing: 5.0,
                        spacing: 8.0,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          for (var i in skills)
                            UnicornOutlineButton(
                              strokeWidth: 2,
                              radius: 12,
                              gradient: LinearGradient(
                                colors: [appTheme.purple50, appTheme.purple400],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 16),
                                child: Text(
                                  i.toString(),
                                  style: theme.textTheme.bodyLarge!.copyWith(
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
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Reviews",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontFamily: 'Poppins'))),
                      SizedBox(height: 16.v),
                      SizedBox(
                        height: 350,
                        child: ListView.builder(
                          itemCount: 4,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 10, right: 10),
                              child: Column(
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
                                          .copyWith(
                                        height: 1.70,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.v),
                                  CustomRatingBar(
                                    initialRating: 3,

                                    itemCount: 5,
                                    itemSize: 12,

                                    //  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  // CustomRatingBar(initialRating: 0)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.v),
                    ],
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
