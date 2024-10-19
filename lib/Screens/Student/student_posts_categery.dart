
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Controllers/student_dashboard_controller.dart';
import 'package:studentsphere/Widgets/user_horizontal_card.dart';

class StudentPostsViaCategory extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? userProfilePic;
  final int index;
  const StudentPostsViaCategory(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.index,
      this.userProfilePic});

  @override
  State<StudentPostsViaCategory> createState() => _StudentPostsViaCategoryState();
}

class _StudentPostsViaCategoryState extends State<StudentPostsViaCategory> {
  var animateController = Get.put(AnimateController());
  final StudentDashboardController studentDashboardController  =
      Get.put(StudentDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    studentDashboardController.getPosts(widget.index);
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
          return studentDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 18, 40, 136),
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              studentDashboardController.selectedPosts.length,
                          itemBuilder: (context, index) {
                            return UserHorizontalPostCard(
                              postName: studentDashboardController
                                  .selectedPosts[index]["postName"],
                              description: studentDashboardController
                                  .selectedPosts[index]["discription"],
                              postLink: studentDashboardController.selectedPosts[index]["postLink"],
                              date: studentDashboardController.selectedPosts[index]
                                  ["date"],
                              imageUrl: studentDashboardController.selectedPosts[index]
                                  ["postPic"],
                              index: index,
                              postKey: studentDashboardController.selectedPosts[index]
                                  ["postKey"],
                              userUid: widget.userUid,
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                              userProfilePic: widget.userProfilePic,
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
