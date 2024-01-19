import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/chat_text_field.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/widgets/chat_messages.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/user_profile_client_view_screen.dart';
import 'package:ying_3_3/models/user.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';

class ChatScreenIndividual extends StatefulWidget {
  const ChatScreenIndividual({super.key, required this.user});
  final UserModel user;

  @override
  State<ChatScreenIndividual> createState() => _ChatScreenIndividualState();
}

class _ChatScreenIndividualState extends State<ChatScreenIndividual> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.user.uid)
      ..getMessages(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ChatMessages(
                receiverId: widget
                    .user.uid), //widget.user.uid 'fgKnNxiLQRc180qANUgi4tOn7AE2'
            ChatTextField(receiverId: widget.user.uid)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.user != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: value.user!.imageURL.isNotEmpty
                        ? NetworkImage(value.user!.imageURL)
                        : const NetworkImage(
                            'https://static.vecteezy.com/system/resources/previews/004/026/956/original/person-avatar-icon-free-vector.jpg'),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        value.user!.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.user!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color:
                              value.user!.isOnline ? Colors.green : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
      ));
}
