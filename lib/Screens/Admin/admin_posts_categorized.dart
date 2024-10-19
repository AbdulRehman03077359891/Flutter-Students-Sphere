import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/admin_dashboard_controller.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Controllers/business_controller.dart';
import 'package:studentsphere/Screens/Admin/update_post.dart';

class PostsViaCategory extends StatefulWidget {
  final String userUid, userName, userEmail;
  // profilePicture;
  final int index;
  const PostsViaCategory(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      // required this.profilePicture,
      required this.index});

  @override
  State<PostsViaCategory> createState() => _PostsViaCategoryState();
}

class _PostsViaCategoryState extends State<PostsViaCategory> {
  var animateController = Get.put(AnimateController());
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    adminDashboardController.getPosts(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "View Posts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 182, 237, 255),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: Obx(
        () {
          return adminDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 18, 40, 136),
                ))
              : adminDashboardController.selectedPosts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "No Post available. Please add Posts to show them here.",textAlign: TextAlign.center,),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  adminDashboardController.selectedPosts.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  postName: adminDashboardController
                                      .selectedPosts[index]["postName"],
                                  description: adminDashboardController
                                      .selectedPosts[index]["discription"],
                                  date: adminDashboardController
                                      .selectedPosts[index]["date"],
                                  imageUrl: adminDashboardController
                                      .selectedPosts[index]["postPic"],
                                  index: index,
                                  postKey: adminDashboardController
                                      .selectedPosts[index]["postKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                );
                              })
                        ],
                      ),
                    );
        },
      ),
    );
  }
}

class HorizontalPostCard extends StatelessWidget {
  final String postName;
  final String description;
  final String date;
  final String imageUrl;
  final String postKey;
  final int index;
  final String userUid, userName, userEmail;

  const HorizontalPostCard({
    super.key,
    required this.postName,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.index,
    required this.postKey,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimateController>(builder: (animateController) {
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
                  animateController.showSecondPage("$index", imageUrl, context),
              child: Hero(
                tag: "$index",
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: CachedNetworkImage(
                    height: 160,
                    width: 120,
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                  ),
                ),
              ),
            ),
            // Text Information on the right side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    InkWell(
                      onTap: () {
                        // Show a dialog with the full description
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(postName),
                              content: Text(description),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.to(() => UpdatePost(
                                            postKey: postKey,
                                            userUid: userUid,
                                            userName: userName,
                                            userEmail: userEmail,
                                          ));
                                    },
                                    child: const Text("Update")),
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                               AlertDialog(
                                                  title: const Text(
                                                    "Are you sure?",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: const ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Color.fromARGB(255, 18, 40, 136))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    ElevatedButton(
                                                        style: const ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Color.fromARGB(255, 18, 40, 136))),
                                                        onPressed: () {
                                                          final BusinessController businessController = Get.put(BusinessController());
                                                          businessController
                                                              .deletPost(postKey, userUid, userName, userEmail);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ))
                                                  ],
                                                )
                                              );
                                    },
                                    child: const Text("Delete")),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        description,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
          ],
        ),
      );
    });
  }
}
