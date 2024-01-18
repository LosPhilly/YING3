import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/widgets/message_bubble.dart';
import 'package:ying_3_3/models/message.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});
  final String receiverId;

  final messages = [
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content: 'Hello',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'How are you?',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content: 'Fine',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'What are you doing?',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content: 'Nothing',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'Can you help me?',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content:
            'https://images.unsplash.com/photo-1669992755631-3c46eccbeb7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
        sentTime: DateTime.now(),
        messageType: MessageType.image),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'Thank you',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
      senderId: '2',
      receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
      content: 'You are welcome',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'Bye',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content: 'Bye',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        receiverId: '2',
        content: 'See you later',
        sentTime: DateTime.now(),
        messageType: MessageType.text),
    Message(
        senderId: '2',
        receiverId: 'fgKnNxiLQRc180qANUgi4tOn7AE2',
        content: 'See you later',
        sentTime: DateTime.now(),
        messageType: MessageType.text)
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final isTextMessage =
                messages[index].messageType == MessageType.text;
            final isMe = receiverId != messages[index].senderId;
            return isTextMessage
                ? MessageBubble(
                    isMe: isMe,
                    message: messages[index],
                    isImage: false,
                  )
                : MessageBubble(
                    isMe: isMe,
                    message: messages[index],
                    isImage: true,
                  );
          }),
    );
  }
}
