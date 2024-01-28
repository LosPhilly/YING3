import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/GroupGigFeedScreen/AdminView/group_profile_admin_view_profile_screen/group_profile_admin_view_profile_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/BankAccountTabScreen/BankAccountTabScreen/my_cards_bank_account_tab_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/BankAccountTabScreen/my_cards_bank_account_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/my_cards_bank_account_page.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class IndividualMainMenuOneScreen extends StatefulWidget {
  const IndividualMainMenuOneScreen({Key? key}) : super(key: key);

  @override
  State<IndividualMainMenuOneScreen> createState() =>
      _IndividualMainMenuOneScreenState();
}

class UserData {
  final String? imageUrlC;
  final String? name;

  UserData({this.imageUrlC, this.name});
}

class GroupData {
  final String? groupImageUrl;

  GroupData({this.groupImageUrl});
}

class _IndividualMainMenuOneScreenState
    extends State<IndividualMainMenuOneScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userImageUrl = '';
  String? userDisplayName = '';
  String? groupImageDisplayUrl = '';
  String? groupDisplayName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getUserData();
    await getGroupData();
  }

  List<PieAction> buildMenuItems() {
    List<PieAction> menuItems = [];

    if (userDisplayName != null) {
      menuItems.add(
        PieAction(
          tooltip: Text(userDisplayName!),
          onSelect: () {
            Navigator.pushNamed(context, AppRoutes.individualMainMenuScreen);
          },
          child: CircleAvatar(
            radius: 35.h,
            backgroundImage: NetworkImage(userImageUrl!),
          ),
        ),
      );
    }
    //
    //
    //BUG DETECTED ***
    // THE SHOW GROUP INFO ONLY WORKS WITH AN IF STATEMENT FOR GROUPS
    // AND ONLY WORKS WITH AN ELSE IF STATMENT ON INDIVIDUALS
    ////
    if (groupDisplayName != null) {
      menuItems.add(
        PieAction(
          tooltip: Text(groupDisplayName!),
          onSelect: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupProfileAdminViewProfileScreen()));
          },
          child: CircleAvatar(
            radius: 35.h,
            backgroundImage: NetworkImage(groupImageDisplayUrl!),
          ),
        ),
      );
    }

    menuItems.add(
      PieAction(
        tooltip: const Text('Log Out'),
        onSelect: () {
          onTapLogout(context);
        },
        child: const Icon(Icons.logout_rounded),
      ),
    );

    return menuItems;
  }

// GET AND DISPLAY USER OR GROUP INFORMATION START //

  Future<void> getUserData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      var userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
      var userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        var userData = userDocSnapshot.data() as Map<String, dynamic>;
        var imageUrl = userData['userImage'] as String?;
        var userName = userData['name'] as String?;

        if (imageUrl != null && userName != null) {
          setState(() {
            userDisplayName = userName;
            userImageUrl = imageUrl;
          });
        }
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error getting User Menu document: $error');
    }
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

        if (groupImageUrl != null && groupUserName != null) {
          setState(() {
            groupDisplayName = groupUserName;
            groupImageDisplayUrl = groupImageUrl;
          });
        }
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error getting Group User Menu document: $error');
      FirebaseAuth.instance.signOut();
    }
  }

  // GET AND DISPLAY USER OR GROUP INFORMATION END //

  @override
  void dispose() {
    fetchData();
    getGroupData();
    getUserData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return PieCanvas(
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 28.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 782.v,
                    width: 347.h,
                    margin: EdgeInsets.only(left: 28.h),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 776.v,
                            width: 221.h,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                        'assets/images/img_menu_gig_button.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 90.v),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userImageUrl!.isEmpty
                                    ? const CircularProgressIndicator()
                                    : CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            NetworkImage(userImageUrl!),
                                      ),
                                SizedBox(height: 12.v),
                                Text("Hi, ${userDisplayName!} ",
                                    style: CustomTextStyles.titleMediumBold)
                              ],
                            ),
                          ),
                        ),
                        PieMenu(
                          onPressed: () {},
                          actions: buildMenuItems(),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.switch_access_shortcut,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Switch Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 108.v),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        CustomImageView(
                                          svgPath: ImageConstant
                                              .imgOutlineuserPrimarycontainer,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.h, top: 3.v),
                                          child: Text(
                                            "My Groups",
                                            style: CustomTextStyles
                                                .titleSmallPrimaryContainer_3,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 29.v),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant
                                                .imgOutlineaddPrimarycontainer,
                                            height: 24.adaptSize,
                                            width: 24.adaptSize,
                                            margin: EdgeInsets.only(
                                                top: 10.v, bottom: 12.v),
                                          ),
                                          Container(
                                            width: 64.h,
                                            margin: EdgeInsets.only(left: 20.h),
                                            child: Text(
                                              "Join New Group",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles
                                                  .titleSmallPrimaryContainer_3
                                                  .copyWith(height: 1.70),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 27.v),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyCardsBankAccountTabScreen()));
                                        },
                                        child: Row(children: [
                                          CustomImageView(
                                            svgPath: ImageConstant
                                                .imgOutlinebankcard,
                                            height: 24.adaptSize,
                                            width: 24.adaptSize,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.h, top: 3.v),
                                            child: Text(
                                              "Payments",
                                              style: CustomTextStyles
                                                  .titleSmallPrimaryContainer_3,
                                            ),
                                          ),
                                        ]),
                                      ),
                                      SizedBox(height: 29.v),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant
                                                .imgOutlineactivity,
                                            height: 24.adaptSize,
                                            width: 24.adaptSize,
                                            margin: EdgeInsets.only(
                                                top: 10.v, bottom: 12.v),
                                          ),
                                          Container(
                                            width: 85.h,
                                            margin: EdgeInsets.only(left: 20.h),
                                            child: Text(
                                              "Transaction History",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomTextStyles
                                                  .titleSmallPrimaryContainer_3
                                                  .copyWith(height: 1.70),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 27.v),
                                      Row(children: [
                                        CustomImageView(
                                          svgPath: ImageConstant
                                              .imgOutlineinfocrfrPrimarycontainer,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.h),
                                          child: Text(
                                            "Tutorials",
                                            style: CustomTextStyles
                                                .titleSmallPrimaryContainer_3,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 28.v),
                                      Row(children: [
                                        CustomImageView(
                                          svgPath: ImageConstant
                                              .imgOutlineinfocrfrPrimarycontainer,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.h),
                                          child: Text(
                                            "About YING",
                                            style: CustomTextStyles
                                                .titleSmallPrimaryContainer_3,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 28.v),
                                      Row(children: [
                                        CustomImageView(
                                          svgPath:
                                              ImageConstant.imgOutlinesettings,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.h, top: 2.v),
                                          child: Text(
                                            "Settings",
                                            style: CustomTextStyles
                                                .titleSmallPrimaryContainer_3,
                                          ),
                                        ),
                                      ]),
                                      SizedBox(height: 28.v),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
}

/// Navigates to the welcomeSplashScreen when the action is triggered.
///
/// The [BuildContext] parameter is used to build the navigation stack.
/// When the action is triggered, this function uses the [Navigator] widget
/// to push the named route for the welcomeSplashScreen.
onTapLogout(context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushNamed(context, AppRoutes.userState);
}
