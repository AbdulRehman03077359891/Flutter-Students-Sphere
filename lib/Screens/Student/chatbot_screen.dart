// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:studentsphere/Controllers/chatbot_ai_controller.dart';

class ChatScreen extends StatelessWidget {
  final AIChatController chatController = Get.put(AIChatController());
  final TextEditingController _messageController = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: const Text("Chatbot", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
                ),),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
        backgroundColor: const Color.fromARGB(255, 182, 237, 255)
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Use Obx to make the Chat widget reactive
              return Chat(
                messages: chatController.messages.value, // Access the reactive list properly
                onSendPressed: (types.PartialText message) {
                  chatController.sendMessage(message.text);
                  _messageController.clear();
                },
                user: const types.User(id: 'user-id'),
                theme: const DefaultChatTheme(
                  backgroundColor: Color.fromARGB(255, 182, 237, 255),
                  inputBackgroundColor: Color.fromARGB(31, 18, 40, 136),
                  primaryColor: Color.fromARGB(255, 18, 40, 136),
                  inputTextColor: Color.fromARGB(255, 18, 40, 136),
                ),
              );
            }),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _messageController,
          //           decoration: InputDecoration(
          //             hintText: 'Type a message...',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.send, color: Color.fromARGB(255, 18, 40, 136)),
          //         onPressed: () {
          //           if (_messageController.text.isNotEmpty) {
          //             chatController.sendMessage(_messageController.text);
          //             _messageController.clear(); // Clear the input after sending
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
