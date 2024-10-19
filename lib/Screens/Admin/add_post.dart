import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studentsphere/Controllers/business_controller.dart';
import 'package:studentsphere/Widgets/notification_message.dart';
import 'package:studentsphere/Widgets/text_field_widget.dart';

class AddPost extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const AddPost(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postNameController = TextEditingController();
  TextEditingController postDiscriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  var businessController = Get.put(BusinessController());
  DateTime? selectedDate;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date to today
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

  showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (await businessController
                                .requestPermision(Permission.camera) ==
                            true) {
                          businessController.pickAndCropImage(
                              ImageSource.camera, context);
                          notify(
                              "success", "permision for storage is granted");
                        } else {
                          notify(
                              "error", "permision for storage is not granted");
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 18, 40, 136),
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () async {
                      if (await businessController
                              .requestPermision(Permission.storage) ==
                          true) {
                        businessController.pickAndCropImage(
                            ImageSource.gallery, context);
                        notify(
                            "success", "permision for storage is granted");
                      } else {
                        notify(
                            "error", "permision for storage is not granted");
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 18, 40, 136),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllCategory();
    });
  }

  getAllCategory() {
    businessController.getCategory(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 237, 255),
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: const Text("Add Posts",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 182, 237, 255),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 18, 40, 136),))
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showBottomSheet();
                          },
                          child: businessController.pickedImageFile.value ==
                                  null
                              ? Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/postPlaceHolder.jpeg"),
                                            fit: BoxFit.cover)),
                                  ))
                              : Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 200,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(businessController
                                                .pickedImageFile.value!),
                                            fit: BoxFit.cover)),
                                  )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          labelText: "Post Name",
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: postNameController,
                          focusBorderColor:
                              const Color.fromARGB(255, 18, 40, 136),
                          hintText: "Enter your Post Name",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                        onTap: () {
                          _selectDate(context); // Open the date picker
                        },
                        child: AbsorbPointer(
                          child: TextFieldWidget(
                            labelText: "Deadline",
                            lines: 1,
                            width: MediaQuery.of(context).size.width * 0.95,
                            controller: dateController,
                            focusBorderColor: const Color.fromARGB(255, 18, 40, 136),
                            hintText: "Select Post Date",
                            errorBorderColor: Colors.red,
                            prefixIcon: const Icon(Icons.date_range_outlined,color: Color.fromARGB(255, 18, 40, 136),),
                          ),
                        ),
                      ),const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          labelText: "Post link (optional)",
                          lines: 1,
                          prefixIcon: const  Icon(Icons.link, color: Color.fromARGB(255, 18, 40, 136),),
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: linkController,
                          focusBorderColor:
                              const Color.fromARGB(255, 18, 40, 136),
                          hintText: "Enter your Post Link",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          lines: 8,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: postDiscriptionController,
                          focusBorderColor:
                              const Color.fromARGB(255, 18, 40, 136),
                          hintText: "Enter your Post Discription",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 18, 40, 136),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  hint: businessController.dropDownValue == ""
                                      ? const Text(
                                          "Select Category",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          businessController.dropDownValue
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                  isExpanded: true,
                                  dropdownColor:
                                      const Color.fromARGB(255, 18, 40, 136),
                                  iconEnabledColor: Colors.white,
                                  // value: businessController.dropDownValue,
                                  items: businessController.allCategories
                                      .map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items["name"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      businessController
                                          .setDropDownValue(newValue);
                                    });
                                  }),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size.fromWidth(145),
                              shape: const ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30),
                                ),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 18, 40, 136),
                              shadowColor: Colors.black,
                              elevation: 10,
                            ),
                            onPressed: () {
                              businessController.addPost(
                                  postNameController.text,
                                  dateController.text,
                                  linkController.text,
                                  postDiscriptionController.text,
                                  widget.userUid,
                                  widget.userName,
                                  widget.userEmail,
                                  widget.profilePicture);
                              postNameController.clear();
                              dateController.clear();
                              linkController.clear();
                              postDiscriptionController.clear();
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add_box, color: Colors.white),
                                Text(
                                  "Add Posts",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                            const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                );
        },
      ),
      );
  }
}
