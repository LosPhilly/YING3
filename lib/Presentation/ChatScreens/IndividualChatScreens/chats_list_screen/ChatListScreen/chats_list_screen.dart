import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/user_item.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/search_screen.dart';

import 'package:ying_3_3/providers/firebase_provider.dart';
import 'package:ying_3_3/routes/app_routes.dart';

import 'package:flutter/material.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

/* DUMMY DATA
  final userData = [
    User(
      uid: '1',
      name: 'Hazy',
      email: 'test@test.test',
      imageURL: 'https://i.pravatar.cc/150?img=0',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    User(
      uid: '1',
      name: 'Charlotte',
      email: 'test@test.test',
      imageURL: 'https://i.pravatar.cc/150?img=1',
      isOnline: false,
      lastActive: DateTime.now(),
    ),
    User(
      uid: '2',
      name: 'Ahmed',
      email: 'test@test.test',
      imageURL: 'https://i.pravatar.cc/150?img=2',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    User(
      uid: '3',
      name: 'Prateek',
      email: 'test@test.test',
      imageURL: 'https://i.pravatar.cc/150?img=3',
      isOnline: false,
      lastActive: DateTime.now(),
    ),
  ];
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UsersSearchScreen())),
              icon: const Icon(Icons.search, color: Colors.black),
            ),
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout, color: Colors.black),
            ),
          ],
        ),
        body: Consumer<FirebaseProvider>(builder: (context, value, child) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: value.users.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) =>
                value.users[index].uid != FirebaseAuth.instance.currentUser?.uid
                    ? UserItem(user: value.users[index])
                    : const SizedBox(),
            physics: const BouncingScrollPhysics(),
          );
        }));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the chatsNewMessageScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the chatsNewMessageScreen.
  onTapAirplaneone(BuildContext context) {
    Navigator.pushNamed(context,
        AppRoutes.gigFeedOneScreen); //AppRoutes.chatsNewMessageScreen);
  }
}
