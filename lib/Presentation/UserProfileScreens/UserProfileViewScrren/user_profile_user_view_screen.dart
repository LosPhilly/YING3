import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/MainUserSettingsScreen/user_profile_settings_main_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/DebitCardAccountScreen/my_cards_debit_card_page/my_cards_debit_card_page.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/my_cards_bank_account_page.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/UserProfileViewScrren/UserSchdeule/UserSchedule.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/UserProfileViewScrren/widgets/chipviewchips8_item_widget.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/persistant.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_3.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';

import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_rating_bar.dart';

// ignore_for_file: must_be_immutable
class UserProfileUserViewScreen extends StatefulWidget {
  final String userId;
  const UserProfileUserViewScreen({super.key, required this.userId});

  @override
  State<UserProfileUserViewScreen> createState() =>
      _UserProfileUserViewScreenState();
}

class _UserProfileUserViewScreenState extends State<UserProfileUserViewScreen>
    with TickerProviderStateMixin {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late FocusNode _focusNode;

  String? name;
  String email = '';
  List<String> buttonList = [];
  List<List> buttonIndex = [];
  String imageUrl = '';
  String uid = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;
  late TabController tabviewController;
  int completed = 0;
  int inProgress = 0;
  int experience = 0;
  String jobname = '';

  bool isOnline = false;

  List skills = [];

  onTapImgOutlineburgerme(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.individualMainMenuScreen);
  }

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

  onTapMyschedule(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height *
                1, // Set a height constraint
            child: Column(
              children: [
                const SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.only(
                    left: 21.h,
                    top: 22.v,
                    right: 21.h,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text("My Gig Schedule",
                            style: CustomTextStyles.titleMediumOnPrimaryBold),
                      ),
                      SizedBox(height: 5.v),
                      Center(
                        child: Text(
                            "Have an insight into all the variations of your tasks. Start by choosing one of the following: ",
                            style: CustomTextStyles.bodySmall11),
                      ),
                      SizedBox(height: 2.v),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: fs.Svg(ImageConstant.imgGroup47),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 64.v,
                                  width: 296.h,
                                  child: TabBar(
                                      controller: tabviewController,
                                      labelPadding: EdgeInsets.zero,
                                      labelColor: theme.colorScheme.onPrimary
                                          .withOpacity(0.42),
                                      unselectedLabelColor:
                                          appTheme.cyan700.withOpacity(0.5),
                                      tabs: const [
                                        Tab(
                                          icon: Icon(
                                            Icons.receipt,
                                            color: Colors.black,
                                          ),
                                          text: "Received",
                                        ),
                                        Tab(
                                          icon: Icon(
                                            Icons.post_add_outlined,
                                            color: Colors.black,
                                          ),
                                          text: "Posted",
                                        ),
                                        Tab(
                                          icon: Icon(
                                            Icons.request_quote_rounded,
                                            color: Colors.black,
                                          ),
                                          text: "Requested",
                                        ),
                                      ])),
                              SizedBox(
                                height: 565.v,
                                child: TabBarView(
                                  controller: tabviewController,
                                  children: [
                                    Container(),
                                    const MyGigSchedule(), // MyCardsDebitCardPage()
                                    Container(),
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    _focusNode = FocusNode();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Remove focus when tapping outside of text fields
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        height: size.height * 0.9,
        child: Scaffold(
          body: SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.h, bottom: 24.v, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      height: 88.v,
                      actions: [
                        AppbarIconbutton3(
                            svgPath: ImageConstant.imgOutlinesettingsOnprimary,
                            margin: EdgeInsets.only(
                              left: 25.h,
                              top: 30.v,
                              right: 20.h,
                            ),
                            onTap: () {
                              onTapOutlinesettings(context);
                            })
                      ],
                    ),
                    imageUrl.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                          ),
                    SizedBox(height: 17.v),
                    Center(
                      child: Text(name.toString(),
                          style: CustomTextStyles.titleMediumOnPrimaryBold),
                    ),
                    SizedBox(height: 4.v),
                    Center(
                        child: Text("UX/UI Designer",
                            style: theme.textTheme.bodyMedium)),
                    Center(
                      child: CustomElevatedButton(
                          height: 33.v,
                          width: 163.h,
                          text: "My Schedule",
                          margin: EdgeInsets.only(top: 17.v),
                          buttonStyle: CustomButtonStyles.outlineBlack,
                          buttonTextStyle:
                              CustomTextStyles.titleSmallPrimaryContainerBold,
                          onTap: () {
                            onTapMyschedule(context);
                          }),
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
                    //SizedBox(height: 16.v),
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
                                    style:
                                        CustomTextStyles.titleMediumOnPrimary),
                                SizedBox(height: 3.v),
                                SizedBox(
                                  width: 150.h,
                                  child: Text(
                                    "Extremely satisfied with the skills Joshua showed!",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles.bodySmallOnPrimary_1
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
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the userProfileSettingsOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileSettingsOneScreen.
  onTapOutlinesettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserProfileSettingsMainScreen(
          userId:
              uid), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  /// Navigates to the taskScheduleOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the taskScheduleOneScreen.
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
