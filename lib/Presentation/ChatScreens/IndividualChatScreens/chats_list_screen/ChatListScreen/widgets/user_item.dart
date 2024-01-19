import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chat_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});
  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreenIndividual(user: widget.user))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              // ignore: unnecessary_null_comparison
              backgroundImage: widget.user.imageURL.isNotEmpty
                  ? NetworkImage(widget.user.imageURL)
                  : const NetworkImage(
                      'https://static.vecteezy.com/system/resources/previews/004/026/956/original/person-avatar-icon-free-vector.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                backgroundColor:
                    widget.user.isOnline ? Colors.green : Colors.grey,
                radius: 5,
              ),
            )
          ],
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last Active: ${timeago.format(widget.user.lastActive)}',
          maxLines: 2,
          style: const TextStyle(
              color: mainColor, fontSize: 15, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
