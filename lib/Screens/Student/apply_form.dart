import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studentsphere/Controllers/student_controller.dart';
import 'package:studentsphere/Widgets/gender_choose.dart';
import 'package:studentsphere/Widgets/qualification.dart';
import 'package:studentsphere/Widgets/text_field_widget.dart';

class FormApplication extends StatefulWidget {
  final String postPic;
  final String postKey;
  final String userName;
  final String userUid;
  final String? userProfilePic;
  final String? gender;
  final String? contact;
  final String? dob;
  final String userEmail;
  const FormApplication(
      {super.key,
      required this.userName,
      required this.userUid,
      this.gender = "",
      this.contact = "",
      this.dob = "",
      required this.userEmail,
      required this.postKey,
      required this.postPic, this.userProfilePic});

  @override
  State<FormApplication> createState() => _FormApplicationState();
}

class _FormApplicationState extends State<FormApplication> {
  // var controller = Get.put(FireController());
  final StudentController studentController = Get.put(StudentController());
  @override
  void initState() {
    super.initState();
    _userName.text = widget.userName.isNotEmpty ? widget.userName : "";
    // _address.text = widget.address ?? "";
    _dOB.text = widget.dob ?? "";
    _contact.text = widget.contact ?? "";
    _gender.text = widget.gender ?? "";
    if (widget.gender != null) {
      _selectedGender = widget.gender;
    }
  }

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _dOB = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _cnic = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _qualification = TextEditingController();

  String? _selectedGender;
  String? _selectedQualification;

  // is Form Filled
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(value);

      // Check if the date is not in the future
      if (parsedDate.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Check if the age is reasonable (e.g., not less than 0 or more than 120)
      int age = DateTime.now().year - parsedDate.year;
      if (age < 0 || age > 120) {
        return 'Please enter a valid age';
      }
    } catch (e) {
      return 'Please enter a valid date in the format dd/MM/yyyy';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 182, 237, 255),
          appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: const Color.fromARGB(31, 18, 40, 136),
            foregroundColor: const Color.fromARGB(255, 18, 40, 136),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text(
              "Application Form",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.name,
                        labelText: "User Name",
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        width: MediaQuery.of(context).size.width,
                        validate: (value) {
                          if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
                            return "Start with Capital letter";
                          } else if (value.isEmpty) {
                            return "username required";
                          } else {
                            return null;
                          }
                        },
                        controller: _userName,
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.datetime,
                        width: MediaQuery.of(context).size.width,
                        labelText: "Date of birth",
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        validate: _validateDOB,
                        controller: _dOB,
                        hintText: "dd/MM/yyyy",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GenderChoose(
                        controller: _gender,
                        selectedGender: _selectedGender,
                        onChange: (value) {
                          setState(() {
                            _selectedGender = value;
                            _gender.text = value!;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      QualificationChoose(
                        controller: _qualification,
                        selectedQualification: _selectedQualification,
                        onChange: (value) {
                          setState(() {
                            _selectedQualification = value;
                            _qualification.text = value!;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (!value!.startsWith("03", 0)) {
                            return "Invalid Number";
                          } else if (value.length < 11) {
                            return "Invalid Number Length";
                          } else if (value.length > 11) {
                            return "Invalid Number Length";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        labelText: "Phone",
                        controller: _contact,
                        hintText: "03xxxxxxxxx",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color.fromARGB(255, 18, 40, 136),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Invalid CNIC";
                          } else if (value.length < 13) {
                            return "Invalid Length";
                          } else if (value.length > 13) {
                            return "Invalid Length";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelColor: const Color.fromARGB(255, 18, 40, 136),
                        labelText: "CNIC",
                        controller: _cnic,
                        hintText: "CNIC only numbers ",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor:
                            const Color.fromARGB(255, 18, 40, 136),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color.fromARGB(255, 18, 40, 136),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      studentController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 18, 40, 136),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  backgroundColor:
                                      const Color.fromARGB(255, 18, 40, 136),
                                  shadowColor: Colors.black,
                                  elevation: 10),
                              onPressed: () async {
                                if (_goodToGo.currentState!.validate()) {
                                  studentController.formRequest(
                                      widget.userUid,
                                      _userName.text,
                                      widget.userEmail,
                                      widget.userProfilePic,
                                      _contact.text,
                                      _cnic.text,
                                      _gender.text,
                                      _qualification.text,
                                      widget.postKey,
                                      widget.postPic);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
