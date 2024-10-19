import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Controllers/student_controller.dart';

class StudentsRequests extends StatefulWidget {
  final String userUid, userName, userEmail;
  // profilePicture;
  // final int index;
  const StudentsRequests({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    // required this.profilePicture,
    // required this.index
  });

  @override
  State<StudentsRequests> createState() => _StudentsRequestsState();
}

class _StudentsRequestsState extends State<StudentsRequests> {
  var animateController = Get.put(AnimateController());
  final StudentController studentController = Get.put(StudentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    studentController.fetchRequests(widget.userUid);
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
          "Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 182, 237, 255),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: Obx(
        () {
          return studentController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 18, 40, 136),
                ))
              : studentController.req.isEmpty
                  ? const Center(
                      child: Text(
                        "No requests available",
                        style: TextStyle(
                            color: Color.fromARGB(255, 18, 40, 136),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: studentController.req.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  studentsName: studentController.req[index]
                                      ["studentName"],
                                  studentsEmail: studentController.req[index]
                                      ["studentEmail"],
                                  appliedAt: studentController.req[index]
                                      ["appliedAt"],
                                  postPic: studentController.req[index]
                                      ["postPic"],
                                  index: index,
                                  reqKey: studentController.req[index]
                                      ["reqKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                  studentCnic: studentController.req[index]
                                      ["studentCnic"],
                                  qualification: studentController.req[index]
                                      ["studentQualification"],
                                  status: studentController.req[index]
                                      ["status"],
                                      studentContact: studentController.req[index]
                                      ["studentContact"],
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
  final String studentsName;
  final String studentsEmail;
  final String appliedAt;
  final String postPic;
  final String reqKey;
  final String studentCnic;
  final String status;
  final String qualification;
  final String studentContact;
  final int index;
  final String userUid, userName, userEmail;

  const HorizontalPostCard({
    super.key,
    required this.studentsName,
    required this.studentsEmail,
    required this.appliedAt,
    required this.postPic,
    required this.index,
    required this.reqKey,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.studentCnic,
    required this.status,
    required this.qualification,
    required this.studentContact,
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
                  animateController.showSecondPage("$index", postPic, context),
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
                    imageUrl: postPic,
                  ),
                ),
              ),
            ),
            // Text Information on the right side
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Name
                      Text(
                        studentsName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 18, 40, 136)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        studentsEmail,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Contact: $studentContact",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        qualification,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      // appliedAt
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                        status,
                        style:  TextStyle(
                            fontSize: 14, color: status == "pending"? Colors.grey.shade600: status == "Accepted"? Colors.green: Colors.red,fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                          Text(
                            "Applied at:$appliedAt",
                            style:
                                const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
