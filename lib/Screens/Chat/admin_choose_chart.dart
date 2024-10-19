import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/chat_controller.dart';
import 'package:studentsphere/Helper/globle.dart';
import 'package:studentsphere/Screens/Chat/message_screen.dart';

class AdminChatsScreen extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? profilePicture;
  final bool status;

  const AdminChatsScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    this.profilePicture, 
    required this.status,
  });

  @override
  State<AdminChatsScreen> createState() => _AdminChatsScreenState();
}

class _AdminChatsScreenState extends State<AdminChatsScreen> {
  var chatController = Get.put(ChatController());
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getConversation();
    });
  }

  getConversation() async {
    await chatController.getConversation(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 237, 255),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
        backgroundColor: const Color.fromARGB(31, 18, 40, 136),
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return chatController.getCon.isEmpty? const Center(child: Text("No Conversation Available"),) : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatController.getCon.length,
                itemBuilder: (context, index) => ChatCard(
                  time: chatController.getCon[index]["lastMessageAt"]?? Timestamp.now(),
                  lastMessage: chatController.getCon[index]["lastMessage"],
                  rPic: chatController.getCon[index]["senderPic"],
                  recieverName: chatController.getCon[index]["senderName"],
                  press: () {
                    conversationId = chatController.getCon[index]["conversationId"];
                    Get.to(MessagesScreen(
                        status: widget.status,
                        recieverId: chatController.getCon[index]["recieverId"],
                        recieverName: chatController.getCon[index]["recieverName"],
                        recieverEmail: chatController.getCon[index]["recieverEmail"],
                        recieverPic: chatController.getCon[index]["recieverPic"],
                        senderId: chatController.getCon[index]["senderId"],
                        senderName: chatController.getCon[index]["senderName"],
                        senderEmail: chatController.getCon[index]["senderEmail"],
                        senderPic: chatController.getCon[index]["senderPic"],
                        conversationId: chatController.getCon[index]
                            ["conversationId"],
                            lastMessage: chatController.getCon[index]["lastMessage"],
                            lastMessageAt: chatController.getCon[index]["lastMessageAt"]?? Timestamp.now(),
                            createdAt: chatController.getCon[index]["createdAt"]?? Timestamp.now(),));
                  },
                ),
              ),
            ),
          ],
        );
      })
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.press,
    this.rPic,
    required this.recieverName,
    required this.lastMessage,
    required this.time,
  });
  final String? rPic;
  final VoidCallback press;
  final String recieverName, lastMessage;
  final Timestamp time; // Assuming you're passing a Firestore Timestamp object

  @override
  Widget build(BuildContext context) {
    // Get the current time
    DateTime now = DateTime.now();

    // Convert Firestore Timestamp to DateTime
    DateTime lastMessageTime = time.toDate();

    // Calculate the difference in time
    Duration difference = now.difference(lastMessageTime);

    // Display the time difference
    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = "Just now";
    } else if (difference.inMinutes < 60) {
      timeAgo = "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      timeAgo = "${difference.inHours} hr ago";
    } else {
      timeAgo = "${difference.inDays} day(s) ago";
    }

    return InkWell(
      onTap: press,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 * 0.75),
        child: Row(
          children: [
            CircleAvatarWithActiveIndicator(
              image: rPic,
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: Text(
                          recieverName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: 0.64,
                          child: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Text(
                          timeAgo, // Show the time difference
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
    this.isActive = false,
  });

  final String? image;
  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
backgroundImage: image == null
      ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image placeholder
      : CachedNetworkImageProvider(image!) as ImageProvider,        ),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF00BF6D),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          )
      ],
    );
  }
}