import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/search_screen.dart';
import 'package:ying_3_3/Presentation/ChatScreens/widgets/favorite_contacts.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/recent_chats.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';
import 'package:ying_3_3/widgets/category_selector.dart';

class ChatScreenMain extends StatefulWidget {
  @override
  _ChatScreenMainState createState() => _ChatScreenMainState();
}

class _ChatScreenMainState extends State<ChatScreenMain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    UserModel user1 = UserModel(
      uid: _auth.currentUser!.uid,
      name: _auth.currentUser!.displayName.toString(),
      email: _auth.currentUser!.email.toString(),
      imageURL: '',
      lastActive: DateTime.now(),
    );
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 3,
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UsersSearchScreen())),
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            CategorySelector(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, //Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    FavoriteContacts(),
                    RecentChats(
                      user: user1, // currentUser is of type UserModel
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
