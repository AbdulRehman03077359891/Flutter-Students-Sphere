// ignore_for_file: prefer_const_constructors

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Helper/const.dart';

class ChatGPTScreen extends StatefulWidget {
  final String userUid, userName, userEmail;

  const ChatGPTScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  late final OpenAI _openAi;
  late final ChatUser _currentUser;
  final ChatUser _chatGpt = ChatUser(id: "1", firstName: "Chat", lastName: "GPT");

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(
      id: widget.userUid,
      firstName: widget.userName,
      lastName: "Student",
    );

    _openAi = OpenAI.instance.build(
      token: OPEN_API_KEY,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Chat GPT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 182, 237, 255),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: DashChat(
        messageOptions: MessageOptions(
          currentUserContainerColor: const Color.fromARGB(255, 182, 237, 255),
          currentUserTextColor: const Color.fromARGB(255, 18, 40, 136),
        ),
        currentUser: _currentUser,
        onSend: (ChatMessage m) => getChatResponse(m),
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
  // Insert the user's message at the beginning of the list
  setState(() {
    _messages.insert(0, m);
  });

  // Create a history of messages for the OpenAI request as a list of maps
  List<Map<String, dynamic>> _messagesHistory = _messages.map((message) {
    return {
      'role': message.user == _currentUser ? 'user' : 'assistant',
      'content': message.text,
    };
  }).toList();

  // Prepare the request for the OpenAI API
  final request = ChatCompleteText(
    model: Gpt40314ChatModel(), // or your desired model
    messages: _messagesHistory,
    maxToken: 200,
  );

  // Get the response from the OpenAI API
  final response = await _openAi.onChatCompletion(request: request);

  // Update the UI with the response from ChatGPT
  if (response != null && response.choices.isNotEmpty) {
    final content = response.choices.first.message?.content ?? 'Sorry, I did not understand that.';
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          user: _chatGpt,
          createdAt: DateTime.now(),
          text: content,
        ),
      );
    });
  }
}
}
