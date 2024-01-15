import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:intl/intl.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/MainUserSettingsScreen/user_profile_settings_main_screen.dart';
import 'package:ying_3_3/core/constants/color_map.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  onTapLogout(context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, AppRoutes.userState);
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
        padding: const EdgeInsets.all(15.0),
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
            appBarColor: Colors.white,
            title: Text(
              'Notifications',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          key: _sliderDrawerKey,
          sliderOpenSize: 179,
          child: Scaffold(
            body: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot notification =
                        (snapshot.data! as dynamic).docs[index];

                    // Get the notification message and timestamp
                    String? postUrl = notification['postUrl'];
                    String message = notification['message'];
                    Timestamp timestamp = notification['timestamp'];
                    DateTime dateTime = timestamp.toDate();

                    // Calculate how long ago the notification took place
                    Duration timeAgo = DateTime.now().difference(dateTime);
                    String timeAgoString = _formatTimeAgo(timeAgo);

                    return InkWell(
                      onTap: () {},
                      /* {
                  // Send the user to the post
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: notification['postId']),
                    ),
                  );
                }, */
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            notification['profilePictureUrl'] ??
                                'https://st.depositphotos.com/2218212/3092/i/600/depositphotos_30920521-stock-photo-facebook-profiles.jpg',
                          ),
                        ),
                        title: Text(message),
                        subtitle: Text(timeAgoString),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(Duration duration) {
    if (duration.inDays > 365) {
      int years = (duration.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (duration.inDays > 30) {
      int months = (duration.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'} ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
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
      color: Colors.white,
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
              color: Colors.black,
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
                color: Colors.black, fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap?.call(title));
  }
}

class Menu {
  final IconData iconData;
  final String title;

  Menu(this.iconData, this.title);
}
