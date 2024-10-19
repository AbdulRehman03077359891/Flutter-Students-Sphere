import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/admin_dashboard_controller.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Screens/Admin/request_details.dart';

class ViewRequests extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String? userProfilePic;
  // final int index;
  const ViewRequests({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    this.userProfilePic,
    // required this.index
  });

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
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
    adminDashboardController.fetchRequests();
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
          return adminDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 18, 40, 136),
                ))
              : adminDashboardController.req.isEmpty
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
                              itemCount: adminDashboardController.req.length,
                              itemBuilder: (context, index) {
                                return HorizontalPostCard(
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                  userProfilePic: widget.userProfilePic,
                                  studentUid: adminDashboardController
                                      .req[index]["studentUid"],
                                  studentName: adminDashboardController
                                      .req[index]["studentName"],
                                  studentEmail: adminDashboardController
                                      .req[index]["studentEmail"],
                                  studentPic: adminDashboardController.req[index]["studentPic"],
                                  studentCnic: adminDashboardController
                                      .req[index]["studentCnic"],
                                  qualification: adminDashboardController
                                      .req[index]["studentQualification"],
                                  studentContact: adminDashboardController
                                      .req[index]["studentContact"],
                                  studentGender: adminDashboardController
                                      .req[index]["studentGender"],
                                  appliedAt: adminDashboardController.req[index]
                                      ["appliedAt"],
                                  postKey: adminDashboardController.req[index]
                                      ["postKey"],
                                  postPic: adminDashboardController.req[index]
                                      ["postPic"],
                                  index: index,
                                  reqKey: adminDashboardController.req[index]
                                      ["reqKey"],
                                  status: adminDashboardController.req[index]
                                      ["status"],
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
  final String userUid;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String studentUid;
  final String studentGender;
  final String postKey;
  final String studentName;
  final String studentEmail;
  final String? studentPic;
  final String appliedAt;
  final String postPic;
  final String reqKey;
  final String studentCnic;
  final String status;
  final String qualification;
  final String studentContact;
  final int index;

  const HorizontalPostCard({
    super.key,
    required this.studentName,
    required this.studentEmail,
    required this.appliedAt,
    required this.postPic,
    required this.index,
    required this.reqKey,
    required this.studentCnic,
    required this.status,
    required this.qualification,
    required this.studentContact,
    required this.studentUid,
    required this.studentGender,
    required this.postKey, required this.userUid, required this.userName, required this.userEmail, this.userProfilePic, this.studentPic,
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
                onTap: () {
                  Get.to(RequestDetailScreen(
                    userUid: userUid,
                    userName: userName,
                    userEmail: userEmail,
                    userProfilePic: userProfilePic,
                    studentUid: studentUid,
                    studentName: studentName,
                    studentEmail: studentEmail,
                    studentPic: studentPic,
                    studentContact: studentContact,
                    studentCnic: studentCnic,
                    studentGender: studentGender,
                    studentQualification: qualification,
                    postKey: postKey,
                    postPic: postPic,
                    status: status,
                    appliedAt: appliedAt,
                    reqKey: reqKey,
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Name
                      Text(
                        studentName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 18, 40, 136)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        studentEmail,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                                fontSize: 14,
                                color: status == "pending"
                                    ? Colors.grey.shade600
                                    : status == "Accepted"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Applied at:$appliedAt",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
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
