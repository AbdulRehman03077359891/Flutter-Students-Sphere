import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/fire_controller.dart';
import 'package:studentsphere/Controllers/student_controller.dart';
import 'package:studentsphere/Screens/Student/apply_form.dart';

class PostDetailScreen extends StatefulWidget {
  final String postName;
  final String description;
  final String date;
  final String? postLink;
  final String imageUrl;
  final String userUid;
  final String userName;
  final String userEmail;
  final String? userProfilePic;
  final String postKey;

  const PostDetailScreen({
    super.key,
    required this.postName,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.postKey, 
    this.postLink, this.userProfilePic,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final FireController fireController = Get.put(FireController());
  final StudentController studentController = Get.put(StudentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.postName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 237, 255),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the post image
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 16),
              // Display the post description
              const Text(
                "Description",
                style: TextStyle(
                    color: Color.fromARGB(255, 18, 40, 136),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              // Display the post date
              Text(
                'Deadline : ${widget.date.toString()}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              // Button to apply
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.postLink== null? 
                    // Handle apply button functionality here
                    Get.to((FormApplication(
                      userName: fireController.userData["userName"],
                      userUid: widget.userUid,
                      userProfilePic: widget.userProfilePic,
                      gender: fireController.userData["userGender"],
                      contact: fireController.userData["userContact"],
                      dob: fireController.userData["dateOfBirth"],
                      userEmail: fireController.userData["userEmail"],
                      postKey: widget.postKey, postPic: widget.imageUrl,
                    ))): studentController.openLink(widget.postLink);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 40, 136),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
