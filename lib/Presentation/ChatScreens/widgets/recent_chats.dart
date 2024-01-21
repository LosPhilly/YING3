import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chat_screen.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/user_item.dart';
import 'package:ying_3_3/models/message.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';

class RecentChats extends StatefulWidget {
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
      builder: (context, value, child) {
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: value.users.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) => value.users[index].uid !=
                        FirebaseAuth.instance.currentUser?.uid
                    ? UserItem(user: value.users[index])
                    : const SizedBox(),
                physics: const BouncingScrollPhysics(),
              ),
            ),
          ),
        );
      },
    );
  }
}
