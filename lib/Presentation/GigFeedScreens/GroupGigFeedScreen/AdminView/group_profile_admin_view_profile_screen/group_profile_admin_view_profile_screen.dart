import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ying_3_3/Presentation/ChatScreens/main_chat_screen.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/widgets/storiescolumn_item_widget.dart';
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
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_3.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_4.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_Group.dart';
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
import 'package:ying_3_3/widgets/group_Nav.dart';

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

class GroupData {
  final String? groupImageUrl;
  final String? groupName;
  final String? groupCode;

  GroupData({this.groupImageUrl, this.groupName, this.groupCode});
}

class _GroupProfileAdminViewProfileScreenState
    extends State<GroupProfileAdminViewProfileScreen>
    with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? groupImageDisplayUrl = '';
  String? groupDisplayName = '';
  String? groupInviteCode = '';

  bool newMessage = false;
  String? jobCategoryFilter;
  // Create a variable to store the length of the snapshot
  int numberOfGigs = 0;

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
    fetchData();
    Persistent persistentObject = Persistent();
    persistentObject.getUserData();
    WidgetsBinding.instance.addObserver(this);
    notificationService.firebaseNotification(context);
  }

  Future<void> fetchData() async {
    await getGroupData();
  }

  Future<void> getGroupData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      var groupDocRef =
          FirebaseFirestore.instance.collection('groups').doc(uid);
      var groupDocSnapshot = await groupDocRef.get();

      if (groupDocSnapshot.exists) {
        var groupData = groupDocSnapshot.data() as Map<String, dynamic>;
        var groupImageUrl = groupData['groupImage'] as String?;
        var groupUserName = groupData['groupName'] as String?;
        var groupInvite = groupData['groupCode'] as String?;

        if (groupImageUrl != null && groupUserName != null) {
          setState(() {
            groupDisplayName = groupUserName;
            groupImageDisplayUrl = groupImageUrl;
            groupInviteCode = groupInvite;
          });
        }
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error getting Group User Menu document: $error');
      FirebaseAuth.instance.signOut();
    }
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
                                    const GroupNav(initialIndex: 1),
                              ),
                            );
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
                                    const GroupNav(initialIndex: 4),
                              ),
                            );
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        toolbarHeight: 90.h, // Adjust the height to your preference
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: Align(
          alignment:
              Alignment.bottomLeft, // Align the leading icon to the bottom
          child: IconButton(
            onPressed: () => Navigator.pushNamed(
                context, AppRoutes.individualMainMenuScreen),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        title: const Center(
          child: Align(alignment: Alignment.bottomCenter, child: Text('')),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                _showTaskCategoriesDialog(size: size);
              },
              icon: const Icon(Icons.emoji_flags, color: Colors.white),
            ),
          ),
          Align(
            alignment:
                Alignment.bottomRight, // Align the action icons to the bottom
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    onTapSearchone(context);
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                const SizedBox(width: 1), // Add spacing between icons
                Stack(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            onClickNewMessage();
                          },
                          icon: const Icon(Icons.chat_rounded,
                              color: Colors.white),
                        ),
                        /* AppbarImage(
                          onTap: onClickNewMessage,
                          svgPath: ImageConstant.imgOutlinechattext,
                          margin: EdgeInsets.all(8.0),
                        ), */
                        if (newMessage)
                          Positioned(
                            top: 6.5.v,
                            left: 29.h,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                groupImageDisplayUrl!.isEmpty
                    ? const Text(
                        'Group picture not set',
                        style: TextStyle(color: Colors.white),
                      )
                    : CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(groupImageDisplayUrl!),
                      ),
                Text(
                  groupDisplayName!,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 22.0, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PoppinsRegular',
                      color: Colors.white),
                ),
                AppbarIconbuttonGroup(
                    svgPath: ImageConstant.imgOutlinesettingsOnprimary,
                    margin: EdgeInsets.only(
                      top: 5.v,
                      right: 20.h,
                    ),
                    onTap: () {
                      onTapOutlinesettings(context);
                    }),
              ],
            ),
            SizedBox(height: 23.v),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 23.v),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: fs.Svg(ImageConstant.imgGroup47),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 4.v),
                                  child: Text("Members",
                                      style: CustomTextStyles
                                          .titleMediumOnPrimaryBold)),
                              CustomElevatedButton(
                                  onTap: () {
                                    Share.share(
                                        '${groupDisplayName!} Skill Sharing Group \n Invite Code: ${groupInviteCode} \n https://liveying.com/${groupInviteCode}');
                                  },
                                  height: 32.v,
                                  width: 115.h,
                                  text: "Invite Link",
                                  leftIcon: Container(
                                      margin: EdgeInsets.only(right: 6.h),
                                      child: CustomImageView(
                                          svgPath:
                                              ImageConstant.imgLinkOnprimary)),
                                  buttonStyle: CustomButtonStyles.none,
                                  decoration: CustomButtonStyles
                                      .gradientCyanToGreenDecoration,
                                  buttonTextStyle: CustomTextStyles
                                      .labelLargeOnPrimarySemiBold)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 156.v,
                              child: ListView.separated(
                                padding: EdgeInsets.only(left: 28.h, top: 16.v),
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 15.h);
                                },
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return const StoriescolumnItemWidget();

                                  /* Imagelist1ItemWidget(
                                    onTapImgUserImage: () {
                                      onTapImgUserImage(context);
                                    },
                                  ); */
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.h, top: 1.v),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusStyle.customBorderTL40),
                                  child: Column(
                                    children: [
                                      Text("Tasks",
                                          style: CustomTextStyles
                                              .titleMediumPrimary),
                                      SizedBox(height: 10.v),
                                      Container(
                                        height: 5.v,
                                        width: 12.h,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 24.h, top: 2.v, bottom: 13.v),
                                  child: Text("Group Tasks",
                                      style: CustomTextStyles
                                          .titleMediumOnPrimary_2),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(1.h, 1.v, 1.h, 1.v),
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
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /* bottomNavigationBar: BottomNavigationBar(
        items: const [
          // Replace 'Text' with 'BottomNavigationBarItem'.
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ), */
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
