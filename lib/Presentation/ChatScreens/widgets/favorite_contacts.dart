import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chat_screen.dart';
import 'package:ying_3_3/models/message_model_Test.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';

class FavoriteContacts extends StatefulWidget {
  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Consumer<FirebaseProvider>(builder: (context, value, child) {
            return SizedBox(
              height: 120.0,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: value.users.length,
                itemBuilder: (context, index) => value.users[index].uid !=
                        FirebaseAuth.instance.currentUser?.uid
                    ? GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreenIndividual(
                                user: value.users[
                                    index]), //ChatScreenIndividual(user: users[index],),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 35.0,
                                backgroundImage: value
                                        .users[index].imageURL.isNotEmpty
                                    ? NetworkImage(value.users[index].imageURL)
                                    : const NetworkImage(
                                        'https://static.vecteezy.com/system/resources/previews/004/026/956/original/person-avatar-icon-free-vector.jpg'),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                value.users[index].name.isNotEmpty
                                    ? value.users[index].name
                                    : '',
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
