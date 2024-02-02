import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/GroupGigFeedScreen/AdminView/group_profile_admin_view_profile_screen/group_profile_admin_view_profile_screen.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/IndividualGigFeedScreen/gig_feed_1_feed_screen.dart';
import 'package:ying_3_3/Presentation/Notifications/IndividualNotificationsScreen/notifications_screen.dart';
import 'package:ying_3_3/Presentation/PostTaskScreens/IndividualPostTaskScreen/individual_post_a_taks_1_screen.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_container_screen.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/UserProfileViewScrren/user_profile_user_view_screen.dart';
import 'package:ying_3_3/theme/theme_helper.dart';

class GroupNav extends StatefulWidget {
  const GroupNav({Key? key, required this.initialIndex}) : super(key: key);
  final int initialIndex; // Add this parameter

  @override
  State<GroupNav> createState() => _NavState();
}

class _NavState extends State<GroupNav> {
  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index; // Update _selectedIndex with the tapped index
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialIndex; // Set the initial index from the widget parameter
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;

    final List<Widget> _widgetOptions = <Widget>[
      GroupProfileAdminViewProfileScreen(),

      SearchContainerScreen(), // Placeholder widget for the second screen
      const IndividualPostATask1Screen(), // Placeholder widget for the third screen
      NotificationsScreen(), // Placeholder widget for the fourth screen
      UserProfileUserViewScreen(
        userId: uid,
      ), // Placeholder widget for the fifth screen
    ];

    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.home,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.home),
            tooltip: 'Home',
            label: 'Home',
          ),
          _buildBottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.search_rounded),
            tooltip: 'Search',
            label: 'Search',
          ),
          _buildBottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.add,
                color: theme.canvasColor,
              ),
            ),
            tooltip: 'Post',
            label: 'Post',
          ),
          _buildBottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.notifications),
            tooltip: 'Notifications',
            label: 'Notifications',
          ),
          _buildBottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.person),
            tooltip: 'Profile',
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required Widget icon,
    required String tooltip,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      tooltip: tooltip,
      label: label,
    );
  }
}
