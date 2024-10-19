import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studentsphere/Controllers/business_controller.dart';

class UpdatePost extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String postKey;

  const UpdatePost({super.key, required this.postKey, required this.userUid, required this.userName, required this.userEmail});

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  TextEditingController postNameController = TextEditingController();
  TextEditingController postDescriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var businessController = Get.put(BusinessController());
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessController.getPostData(widget.postKey).then((_) {
        var postData = businessController.selectedPost;
        postNameController.text = postData['postName'];
        postDescriptionController.text = postData['discription'];
        dateController.text = postData['date'];
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Set to current date or selected date
      firstDate: DateTime.now(), // Only allow dates from today onwards
      lastDate: DateTime(2100), // Set the farthest date allowed
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!); // Format date as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Post",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(31, 18, 40, 136),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: postNameController,
                        decoration: const InputDecoration(labelText: "Post Name"),
                      ),
                      TextField(
                        controller: postDescriptionController,
                        decoration: const InputDecoration(labelText: "Description"),
                        maxLines: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context); // Open the date picker
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: dateController,
                            decoration: const InputDecoration(labelText: "Date"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          backgroundColor: const Color.fromARGB(255, 182, 237, 255),
                          foregroundColor: const Color.fromARGB(255, 18, 40, 136),
                        ),
                        onPressed: () {
                          // Call the update method
                          businessController.updatePost(
                            widget.postKey,
                            postNameController.text,
                            postDescriptionController.text,
                            dateController.text,
                            widget.userUid,
                            widget.userName,
                            widget.userEmail
                          );
                        },
                        child: const Text(
                          "Update Post",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
