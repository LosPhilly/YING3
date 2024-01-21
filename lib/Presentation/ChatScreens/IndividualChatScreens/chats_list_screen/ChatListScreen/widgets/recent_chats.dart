import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chat_screen.dart';
//import 'package:ying_3_3/Presentation/ChatScreens/chat_screen.dart';
import 'package:ying_3_3/models/message.dart';
//import 'package:ying_3_3/models/message.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentChats extends StatefulWidget {
  const RecentChats({super.key, required this.user});
  final UserModel user;
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getAllUsers()
      ..getUserById(widget.user.uid)
      ..getMessages(widget.user.uid);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return Expanded(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: value.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message chat = value.messages[index];
                      final String receiverId = value.users[index].uid;
                      return GestureDetector(
                        onTap: () {
                          Provider.of<FirebaseProvider>(context, listen: false)
                              .updateUnreadSection(
                                  value.messages[index].receiverId,
                                  value.messages[index].messageID);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreenIndividual(
                                user: value.users[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, right: 20.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: chat.unread
                                ? const Color(0xFFFFEFEE)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage: value
                                            .users[index].imageURL.isNotEmpty
                                        ? NetworkImage(
                                            value.users[index].imageURL)
                                        : const NetworkImage(
                                            'https://static.vecteezy.com/system/resources/previews/004/026/956/original/person-avatar-icon-free-vector.jpg'),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
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
                                      const SizedBox(height: 5.0),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Text(
                                          chat.content,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(chat.sentTime),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  const SizedBox(height: 5.0),
                                  chat.unread
                                      ? Container(
                                          width: 40.0,
                                          height: 20.0,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'NEW',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : const Text(''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
