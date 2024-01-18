import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/chat_text_field.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/widgets/chat_messages.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/user_profile_client_view_screen.dart';
import 'package:ying_3_3/models/user.dart';

class ChatScreenIndividual extends StatefulWidget {
  const ChatScreenIndividual({super.key, required this.user});
  final User user;

  @override
  State<ChatScreenIndividual> createState() => _ChatScreenIndividualState();
}

class _ChatScreenIndividualState extends State<ChatScreenIndividual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.user.uid),
            const ChatTextField()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              showDragHandle: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              context: context,
              builder: (BuildContext context) {
                return UserProfileClientViewScreen(userId: widget.user.uid);
              },
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.imageURL),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.user.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                        color:
                            widget.user.isOnline ? Colors.green : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
