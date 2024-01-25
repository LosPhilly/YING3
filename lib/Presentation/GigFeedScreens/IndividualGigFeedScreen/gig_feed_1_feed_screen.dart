import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/chats_list_screen.dart';
import 'package:ying_3_3/Presentation/ChatScreens/main_chat_screen.dart';
import 'package:ying_3_3/Presentation/Notifications/IndividualNotificationsScreen/notifications_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/MainUserSettingsScreen/user_profile_settings_main_screen.dart';
import 'package:ying_3_3/core/constants/color_map.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';
import 'package:ying_3_3/core/constants/persistant.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/services/firebase_firestore_service.dart';
import 'package:ying_3_3/services/notification_service.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_search_view.dart';
import 'package:ying_3_3/widgets/job_widget.dart';

// ignore_for_file: must_be_immutable
class GigFeed1FeedScreen extends StatefulWidget {
  const GigFeed1FeedScreen({Key? key}) : super(key: key);

  @override
  State<GigFeed1FeedScreen> createState() => _GigFeed1FeedScreenState();
}

class UserData {
  final String? imageUrl;
  final String? name;

  UserData({this.imageUrl, this.name});
}

class _GigFeed1FeedScreenState extends State<GigFeed1FeedScreen>
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
    title = "Gig Feed";
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

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  late String title;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: SliderDrawer(
          slider: _SliderView(
            onItemClick: (title) {
              _sliderDrawerKey.currentState!.closeSlider();
              setState(() {
                this.title = title;
              });
              if (title == 'Add Post') {
                Navigator.pushNamed(
                    context, AppRoutes.individualPostTask1Screen2);
              }
              if (title == 'Notification') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NotificationsScreen(), // Replace YourNewPage with the actual page you want to navigate to
                ));
              }
              if (title == 'Settings') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserProfileSettingsMainScreen(
                      userId: user!
                          .uid), // Replace YourNewPage with the actual page you want to navigate to
                ));
              }
              if (title == 'LogOut') {
                onTapLogout(context);
              }
            },
          ),
          appBar: SliderAppBar(
            appBarHeight: 100,
            drawerIconColor: Colors.white,
            appBarColor: Theme.of(context).primaryColor,
            title: Text(
              'Gig Feed',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _showTaskCategoriesDialog(size: size);
                  },
                  icon: const Icon(Icons.emoji_flags, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    onTapSearchone(context);
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                Stack(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            onClickNewMessage();
                          },
                          icon: const Icon(Icons.chat_bubble,
                              color: Colors.white),
                        ),
                        /* AppbarImage(
                          onTap: onClickNewMessage,
                          svgPath: ImageConstant.imgOutlinechattext,
                          margin: EdgeInsets.all(8.0),
                        ), */
                        if (newMessage)
                          Positioned(
                            top: 10.v,
                            left: 25.h,
                            child: Container(
                              width: 10,
                              height: 10,
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
          key: _sliderDrawerKey,
          sliderOpenSize: 179,
          child: Stack(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: jobCategoryFilter == null
                    ? FirebaseFirestore.instance
                        .collection('tasks')
                        .where('recruitment', isEqualTo: true)
                        .orderBy('createAt', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('tasks')
                        .where('taskCategory', isEqualTo: jobCategoryFilter)
                        .where('recruitment', isEqualTo: true)
                        .orderBy('createAt', descending: true)
                        .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    numberOfGigs = snapshot.data?.size ?? 0;
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return Scaffold(
                        body: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.v),
                              Center(
                                child: Text(
                                  numberOfGigs < 2
                                      ? "$numberOfGigs new gig has been added"
                                      : "$numberOfGigs new gigs have been added",
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  height: 32.v,
                                  width: 116.h,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      userImage == null
                                          ? CircularProgressIndicator()
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(userImage),
                                            ),
                                      CustomImageView(
                                          imagePath: ImageConstant.imgEllipse14,
                                          height: 32.adaptSize,
                                          width: 32.adaptSize,
                                          radius: BorderRadius.circular(16.h),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 28.h)),
                                      CustomImageView(
                                          imagePath: ImageConstant.imgEllipse13,
                                          height: 32.adaptSize,
                                          width: 32.adaptSize,
                                          radius: BorderRadius.circular(16.h),
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 28.h)),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h, vertical: 6.v),
                                          decoration: AppDecoration
                                              .gradientCyanToGreen40001
                                              .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder16),
                                          child: Text("28",
                                              style: theme.textTheme.bodySmall),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 2),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Color backgroundColor = categoryColors[
                                            snapshot.data!.docs[index]
                                                .data()['taskCategory']] ??
                                        Colors.grey;
                                    return JobWidget(
                                      jobTitle: snapshot.data!.docs[index]
                                          ['taskTitle'],
                                      jobDescription: snapshot.data!.docs[index]
                                          .data()['taskDescription'],
                                      jobId: snapshot.data!.docs[index]
                                          .data()['taskId'],
                                      uploadedBy: snapshot.data!.docs[index]
                                          .data()['uploadedBy'],
                                      createAt: snapshot.data!.docs[index]
                                          .data()['createAt'],
                                      userImage: snapshot.data!.docs[index]
                                          .data()['userImage'],
                                      name: snapshot.data!.docs[index]
                                          .data()['userName'],
                                      recruitment: snapshot.data!.docs[index]
                                          .data()['recruitment'],
                                      jobCategory: snapshot.data!.docs[index]
                                          .data()['taskCategory'],
                                      email: snapshot.data!.docs[index]
                                          .data()['email'],
                                      location: snapshot.data!.docs[index]
                                          .data()['location'],
                                      backgroundColor: backgroundColor,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('There are no gigs available'),
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
        ),
      ),
    );
  }

  /// Navigates to the individualMainMenuOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the individualMainMenuOneScreen.
  onTapImgOutlineburgerme(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.individualMainMenuScreen);
  }

  /// Navigates to the gigFeed2SearchContainerScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed2SearchContainerScreen.
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
            SizedBox(height: 5),
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
                        CustomIconButton(
                          height: 44.adaptSize,
                          width: 44.adaptSize,
                          padding: EdgeInsets.all(10.h),
                          decoration: IconButtonStyleHelper.fillGray,
                          child: CustomImageView(
                            svgPath:
                                ImageConstant.imgOutlineuserSecondarycontainer,
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
                      CustomIconButton(
                        height: 44.adaptSize,
                        width: 44.adaptSize,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.fillRed,
                        child: CustomImageView(
                          svgPath:
                              ImageConstant.imgOutlinechattextDeepOrange700,
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

  /// Navigates to the gigFeed2TaskDetailsScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed2TaskDetailsScreen.
  onTapRowfitnessmodel(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }
}

class _SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  String? userImageUrl = '';
  String tempProfileImage =
      'https://www.iconpacks.net/icons/3/free-purple-person-icon-10780-thumb.png';

  String? userDisplayName = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    await getUserData();
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

  @override
  Widget build(BuildContext context) {
    colors.shuffle();
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: colors[1],
            child: CircleAvatar(
              radius: 60,
              backgroundImage: userImageUrl!.isEmpty
                  ? NetworkImage(tempProfileImage)
                  : NetworkImage(userImageUrl!),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            userDisplayName!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...[
            Menu(Icons.home, 'Home'),
            Menu(Icons.add_circle, 'Add Post'),
            Menu(Icons.group, 'My Groups'),
            Menu(Icons.group_add, 'Join New Group'),
            Menu(Icons.payment, 'Payments'),
            Menu(Icons.payments, 'Transaction History'),
            Menu(Icons.notifications_active, 'Notification'),
            Menu(Icons.favorite, 'Likes'),
            Menu(Icons.settings, 'Settings'),
            Menu(Icons.info, 'Tutorials'),
            Menu(Icons.info_outlined, 'About YING'),
            Menu(
              Icons.arrow_back_ios,
              'LogOut',
            ),
          ]
              .map((menu) => _SliderMenuItem(
                  title: menu.title,
                  iconData: menu.iconData,
                  onTap: widget.onItemClick))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'PoppinsRegular')),
        leading: Icon(iconData, color: Colors.white),
        onTap: () => onTap?.call(title));
  }
}

class Menu {
  final IconData iconData;
  final String title;

  Menu(this.iconData, this.title);
}
