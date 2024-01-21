import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chat_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/models/message_model_Test.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ying_3_3/providers/firebase_provider.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});
  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
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
    return Consumer<FirebaseProvider>(builder: (context, value, child) {
      return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreenIndividual(user: widget.user))),
        child: Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final Message chat = chats[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreenIndividual(
                      user: value.users[index],
                    ),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: chat.unread ? const Color(0xFFFFEFEE) : Colors.white,
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
                                ? NetworkImage(value.users[index].imageURL)
                                : const NetworkImage(
                                    'https://static.vecteezy.com/system/resources/previews/004/026/956/original/person-avatar-icon-free-vector.jpg'),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  value.messages[index].content,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Last Active: ${timeago.format(widget.user.lastActive)}',
                            maxLines: 2,
                            style: const TextStyle(
                                color: mainColor,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            chat.time,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          chat.unread
                              ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
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
      );
    });
  }
}
