import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ying_3_3/Presentation/ChatScreens/main_chat_screen.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/constants/persistant.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/services/notification_service.dart';
import 'package:ying_3_3/theme/app_decoration.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_4.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_2.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_11.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_6.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_search_view.dart';
import 'package:ying_3_3/widgets/nav.dart';

import '../group_profile_admin_view_profile_screen/widgets/eventpost1_item_widget.dart';
import '../group_profile_admin_view_profile_screen/widgets/imagelist1_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

// ignore_for_file: must_be_immutable
class GroupProfileAdminViewProfileScreen extends StatefulWidget {
  GroupProfileAdminViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<GroupProfileAdminViewProfileScreen> createState() =>
      _GroupProfileAdminViewProfileScreenState();
}

class UserData {
  final String? imageUrl;
  final String? name;

  UserData({this.imageUrl, this.name});
}

class _GroupProfileAdminViewProfileScreenState
    extends State<GroupProfileAdminViewProfileScreen>
    with WidgetsBindingObserver {
  bool newMessage = false;
  String? jobCategoryFilter;
  // Create a variable to store the length of the snapshot
  int numberOfGigs = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool selectedPostContainer = true;
  bool selectedRequestContainer = false;
  final notificationService = NotificationsService();

  late FocusNode _searchFocusNode;
  String temTaskID = '0';

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateLastActive();
    _searchFocusNode = FocusNode();

    Persistent persistentObject = Persistent();
    persistentObject.getUserData();
    WidgetsBinding.instance.addObserver(this);
    notificationService.firebaseNotification(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;
      switch (state) {
        case AppLifecycleState.resumed:
          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'lastActive': DateTime.now(),
            'isOnline': true,
          }); // FirebaseFirestoreService.updateUserData({'lastActive': DateTime.now(),'isOnline': true,})
          break;

        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'isOnline': false});
          break;

        default:
          // Handle the case where the state is unknown.
          break;
      }
    } catch (error) {
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

  updateLastActive() async {
    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'lastActive': DateTime.now(),
      });
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isOnline': true,
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

  onTapLogout(context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  void onTapSearch() {
    // Set the focus on the search field when the search icon is tapped
    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  onTapSearchone(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: false,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            CustomSearchView(
              margin: EdgeInsets.only(right: 28.h),
              controller: searchController,
              autofocus: false,
              hintText: "Search by name, skill or category",
              hintStyle: const TextStyle(color: Colors.black),
              focusNode: _searchFocusNode,
              prefix: Container(
                margin: EdgeInsets.fromLTRB(16.h, 10.v, 8.h, 10.v),
                child: CustomImageView(svgPath: ImageConstant.imgSearch),
              ),
              prefixConstraints: BoxConstraints(maxHeight: 40.v),
              suffix: Padding(
                padding: EdgeInsets.only(right: 15.h),
                child: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(
                left: 21.h,
                top: 28.v,
                right: 21.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomIconButton(
                        height: 44.adaptSize,
                        width: 44.adaptSize,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.fillCyan,
                        child: CustomImageView(
                          svgPath: ImageConstant.imgOutlineheart,
                        ),
                      ),
                      SizedBox(height: 10.v),
                      Text(
                        "Groups",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.v),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Nav(initialIndex: 1)));
                          },
                          child: CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(10.h),
                            decoration: IconButtonStyleHelper.fillGray,
                            child: CustomImageView(
                              svgPath: ImageConstant
                                  .imgOutlineuserSecondarycontainer,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.v),
                        Text(
                          "Members",
                          style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.v),
                    child: Column(
                      children: [
                        CustomIconButton(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Nav(initialIndex: 4)));
                          },
                          height: 44.adaptSize,
                          width: 44.adaptSize,
                          padding: EdgeInsets.all(10.h),
                          decoration: IconButtonStyleHelper.fillPurpleTL16,
                          child: CustomImageView(
                            svgPath: ImageConstant.imgOutlineshopping,
                          ),
                        ),
                        SizedBox(height: 8.v),
                        Text(
                          "Tasks",
                          style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(21.h, 27.v, 21.h, 9.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomIconButton(
                        height: 44.adaptSize,
                        width: 44.adaptSize,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.fillRedTL16,
                        child: CustomImageView(
                          svgPath: ImageConstant.imgOutlinestar,
                        ),
                      ),
                      SizedBox(height: 8.v),
                      Text(
                        "Skills",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreenMain()));
                        },
                        child: CustomIconButton(
                          height: 44.adaptSize,
                          width: 44.adaptSize,
                          padding: EdgeInsets.all(10.h),
                          decoration: IconButtonStyleHelper.fillRed,
                          child: CustomImageView(
                            svgPath:
                                ImageConstant.imgOutlinechattextDeepOrange700,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.v),
                      Text(
                        "Chats",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomIconButton(
                        height: 44.adaptSize,
                        width: 44.adaptSize,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.fillGreenTL16,
                        child: CustomImageView(
                          svgPath: ImageConstant.imgOutlinelistboxes,
                        ),
                      ),
                      SizedBox(height: 8.v),
                      Text(
                        "Feed",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// SHOW CATEGORIES FIELDS ///
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 98, 54, 255).withOpacity(0.5),
          title: const Text(
            'Job Category',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.taskCategoryList.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      jobCategoryFilter = Persistent.taskCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    // ignore: avoid_print
                    print(
                        'jobCategoryList[index], ${Persistent.taskCategoryList[index]}');
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag_circle,
                        color: Colors.green,
                        size: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Persistent.taskCategoryList[index],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  jobCategoryFilter = null;
                  // ignore: avoid_print
                  print(jobCategoryFilter);
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'Cancel Filter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// SHOW CATEGORIES FIELDS END ///

  void onClickNewMessage() {
    if (newMessage == false) {
      setState(() {
        newMessage = true;
      });
    } else if (newMessage == true) {
      setState(() {
        newMessage = false;
      });
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ChatScreenMain())); // Replace YourNewPage with the actual page you want to navigate to
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppBar(
        leadingWidth: 192.h,
        leading: AppbarImage1(
          svgPath: ImageConstant.imgGroup36850,
          margin: EdgeInsets.only(top: 2.v, right: 152.h, bottom: 4.v),
        ),
        title: Container(
          margin: EdgeInsets.only(left: 10.h),
          decoration: AppDecoration.column31,
          child: Column(
            children: [
              AppbarSubtitle(
                text: "Ying Co-Working",
                margin: EdgeInsets.only(left: 41.h),
              ),
              AppbarImage2(
                imagePath: ImageConstant.imgYinglogoblack,
                margin: EdgeInsets.only(right: 163.h),
              ),
              AppbarSubtitle6(
                text: "Short Description",
                margin: EdgeInsets.only(left: 41.h, right: 20.h),
              ),
              AppbarSubtitle11(
                text: "YING",
                margin: EdgeInsets.only(left: 1.h, right: 165.h, bottom: 10.v),
              )
            ],
          ),
        ),
        actions: [
          AppbarIconbutton4(
            svgPath: ImageConstant.imgOutlinesettings,
            margin: EdgeInsets.fromLTRB(28.h, 6.v, 28.h, 9.v),
            onTap: () {
              onTapOutlinesettings(context);
            },
          )
        ],
      ),
      body: SizedBox(
          width: double.maxFinite,
          child: Column(children: [
            SizedBox(height: 23.v),
            Expanded(
                child: SizedBox(
                    width: double.maxFinite,
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 23.v),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: fs.Svg(ImageConstant.imgGroup47),
                                fit: BoxFit.cover)),
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28.h),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 4.v),
                                        child: Text("Members",
                                            style: CustomTextStyles
                                                .titleMediumOnPrimaryBold)),
                                    CustomElevatedButton(
                                        height: 32.v,
                                        width: 115.h,
                                        text: "Invite Link",
                                        leftIcon: Container(
                                            margin: EdgeInsets.only(right: 6.h),
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgLinkOnprimary)),
                                        buttonStyle: CustomButtonStyles.none,
                                        decoration: CustomButtonStyles
                                            .gradientCyanToGreenDecoration,
                                        buttonTextStyle: CustomTextStyles
                                            .labelLargeOnPrimarySemiBold)
                                  ])),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      height: 156.v,
                                      child: ListView.separated(
                                          padding: EdgeInsets.only(
                                              left: 28.h, top: 16.v),
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(width: 15.h);
                                          },
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Imagelist1ItemWidget(
                                                onTapImgUserImage: () {
                                              onTapImgUserImage(context);
                                            });
                                          })))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 28.h, top: 48.v),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadiusStyle
                                                    .customBorderTL40),
                                            child: Column(children: [
                                              Text("Tasks",
                                                  style: CustomTextStyles
                                                      .titleMediumPrimary),
                                              SizedBox(height: 10.v),
                                              Container(
                                                  height: 5.v,
                                                  width: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.h)))
                                            ])),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.h,
                                                top: 2.v,
                                                bottom: 13.v),
                                            child: Text("Group Tasks",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary_2))
                                      ]))),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(28.h, 16.v, 28.h, 99.v),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 241.v,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 15.h,
                                          crossAxisSpacing: 15.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Eventpost1ItemWidget(
                                        onTapImgProjectName: () {
                                      onTapImgProjectName(context);
                                    });
                                  }))
                        ]))))
          ])),
    );
  }

  /// Navigates to the groupGigFeedTaskDetailsScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupGigFeedTaskDetailsScreen.
  onTapImgProjectName(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the groupProfileClientViewMemberScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupProfileClientViewMemberScreen.
  onTapImgUserImage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the groupProfileAdminViewSettingsScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupProfileAdminViewSettingsScreen.
  onTapOutlinesettings(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
