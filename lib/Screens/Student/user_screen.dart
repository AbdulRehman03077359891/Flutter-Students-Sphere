import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/student_dashboard_controller.dart';
import 'package:studentsphere/Screens/Student/chat_gpt_screen.dart';
import 'package:studentsphere/Screens/Student/student_posts_categery.dart';
import 'package:studentsphere/Widgets/user_drawer_widget.dart';
import 'package:studentsphere/Widgets/user_horizontal_card.dart';

class StudentScreen extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? userProfilePic;

  const StudentScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail, this.userProfilePic,

  });

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentDashboardController studentDashboardController =
      Get.put(StudentDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentDashboardController.getDashBoardData();
    });
  }

  List imagesList = [
    "assets/images/adver1.jpg",
    "assets/images/adver2.jpeg",
    "assets/images/adver3.jpeg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(31, 18, 40, 136),
        centerTitle: true,
        titleSpacing: 1,
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 85,
                child: Image.asset('assets/images/studentsphere_logo.png'),
              ),
            ),
            const Text(
              'Student Sphere',
              style: TextStyle(
                  shadows: [BoxShadow(blurRadius: 10, spreadRadius: 20)]),
            ),
          ],
        ),
      ),
      drawer: StudentDrawerWidget(
        userUid: widget.userUid,
        accountName: widget.userName,
        accountEmail: widget.userEmail,
      ),
      body: Obx(() {
        if (studentDashboardController.cat.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CarouselSlider.builder(
                    itemCount: studentDashboardController.cat.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      // final category = studentDashboardController.cat[itemIndex];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(StudentPostsViaCategory(
                                    userUid: widget.userUid,
                                    userName: widget.userName,
                                    userEmail: widget.userEmail,
                                    userProfilePic: widget.userProfilePic,
                                    index: itemIndex,
                                  ));
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      studentDashboardController.cat[itemIndex]
                                          ["name"],
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 18, 40, 136),
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          BoxShadow(
                                              blurRadius: 2, spreadRadius: 2),
                                        ],
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${studentDashboardController.cat[itemIndex]["postCount"] ?? 0} Posts',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: .60,
                      height: 100,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 4),
                    ),
                  )),
              CarouselSlider.builder(
                itemCount: imagesList.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  // final category = studentDashboardController.cat[itemIndex];
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        imagesList[itemIndex],
                        fit: BoxFit.fitWidth,
                      ));
                },
                options: CarouselOptions(
                  viewportFraction: .90,
                  // height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: studentDashboardController.posts.length,
                itemBuilder:
                    (BuildContext context, int index) {
                  // return Card();
                  // final category = studentDashboardController.cat[itemIndex];
                  return UserHorizontalPostCard(
                      postName: studentDashboardController.posts[index]
                              ["postName"] ??
                          '',
                      description: studentDashboardController.posts[index]
                              ["discription"] ??
                          '',
                      postLink: studentDashboardController.posts[index]["postLink"],
                      date: studentDashboardController.posts[index]
                              ["date"] ??
                          '',
                      imageUrl: studentDashboardController.posts[index]
                              ["postPic"] ??
                          '',
                      index: index,
                      postKey: studentDashboardController.posts[index]
                              ["postKey"] ??
                          '',
                      userUid: widget.userUid,
                      userName: widget.userName,
                      userEmail: widget.userEmail);
                },
              )
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChatGPTScreen(userUid: widget.userUid, userName: widget.userName, userEmail: widget.userEmail));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
