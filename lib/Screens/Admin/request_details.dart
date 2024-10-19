import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/admin_dashboard_controller.dart';
import 'package:studentsphere/Controllers/chat_controller.dart';
import 'package:studentsphere/Widgets/e1_button.dart';

class RequestDetailScreen extends StatelessWidget {
  final String userUid;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String studentUid;
  final String studentName;
  final String studentEmail;
  final String studentContact;
  final String studentCnic;
  final String studentGender;
  final String studentQualification;
  final String? studentPic;
  final String postKey;
  final String postPic;
  final String status;
  final String appliedAt;
  final String reqKey;

  const RequestDetailScreen({
    super.key,
    required this.studentUid,
    required this.studentName,
    required this.studentEmail,
    required this.studentContact,
    required this.studentCnic,
    required this.studentGender,
    required this.studentQualification,
    required this.postKey,
    required this.postPic,
    required this.status,
    required this.appliedAt,
    required this.reqKey, required this.userUid, required this.userName, required this.userEmail, this.userProfilePic, this.studentPic,
  });

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController adminDashboardController =
        Get.put(AdminDashboardController());
    final ChatController chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Request Details',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: ListView(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Details",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 18, 40, 136)),
            ),
          ),
          const Divider(),
          buildDetailRow('Student Name:', studentName),
          buildDetailRow('Student Email:', studentEmail),
          buildDetailRow('Student Contact:', studentContact),
          buildDetailRow('Student CNIC:', studentCnic),
          buildDetailRow('Gender:', studentGender),
          buildDetailRow('Qualification:', studentQualification),
          buildDetailRow('Status:', status),
          buildDetailRow('Applied At:', appliedAt),
          const SizedBox(height: 20),
          const Divider(),
          postPic.isNotEmpty
              ? Image.network(
                  postPic,
                  fit: BoxFit.fitWidth,
                )
              : const SizedBox(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              E1Button(
                  onPressed: () {
                    adminDashboardController.updateRequest(reqKey, 'Rejected');
                  },
                  backColor: const Color.fromARGB(255, 182, 237, 255),
                  text: "Reject",
                  textColor: const Color.fromARGB(255, 18, 40, 136)),
              E1Button(
                  onPressed: () {
                    adminDashboardController.updateRequest(reqKey, 'Accepted');
                    chatController.createConversation(userUid, userName, userEmail, userProfilePic, studentUid, studentName, studentEmail, studentPic);
                  },
                  backColor: const Color.fromARGB(255, 182, 237, 255),
                  text: "Accept",
                  textColor: const Color.fromARGB(255, 18, 40, 136))
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
