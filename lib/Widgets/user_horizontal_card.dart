
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Screens/Student/post_detail_screen.dart';

class UserHorizontalPostCard extends StatelessWidget {
  final String postName;
  final String description;
  final String? postLink;
  final String date;
  final String imageUrl;
  final String postKey;
  final int? index;
  final String userUid, userName, userEmail;
  final String? userProfilePic;

  const UserHorizontalPostCard({
    super.key,
     required this.postName,
     required this.description,
     required this.date,
     required this.imageUrl,
     this.index,
     required this.postKey,
     required this.userUid,
     required this.userName,
     required this.userEmail,
     this.postLink, this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    final AnimateController animateController = Get.put(AnimateController());
    // return GetBuilder<AnimateController>(builder: (animateController) {
      return Card(
        color: const Color.fromARGB(255, 182, 237, 255),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            // Post Image on the left side
            GestureDetector(
              onTap: () =>
                  animateController.showSecondPage("P$index", imageUrl, context),
              child: Hero(
                tag: "P$index",
                child: 
    ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: 
                    CachedNetworkImage(
                    
                    height: 160,
                    width: 120,
                    fit: BoxFit.cover, imageUrl: imageUrl,
                  ),
                ),
              ),
            ),
            // Text Information on the right side
            Expanded(
              child: 
            InkWell(
                onTap: () {
                   Get.to(() => PostDetailScreen(
          postName: postName,
          description: description,
          postLink: postLink,
          date: date,
          imageUrl: imageUrl,
          userUid: userUid,
          userName: userName,
          userEmail: userEmail,
          userProfilePic: userProfilePic,
          postKey: postKey,
        ));
                },
                child: 
    Padding(
                  padding: const EdgeInsets.all(10),
                  child: 
    SingleChildScrollView(
      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Post Name
                        Text(
                          postName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 18, 40, 136)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        // Description with tap functionality
      Text(
                            description,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        // Date
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            date,
                            style:
                                const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
    ),
                ),
              ),
            ),
          ],
        ),
      );
    // });
  }
}
