import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studentsphere/Controllers/admin_controller.dart';
import 'package:studentsphere/Widgets/notification_message.dart';
import 'package:studentsphere/Widgets/text_field_widget.dart';

class AddCategory extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const AddCategory(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();
  var adminController = Get.put(AdminController());
  TextEditingController editingController = TextEditingController();
  late int selectedIndex;

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
                        if (await adminController
                                .requestPermision(Permission.camera) ==
                            true) {
                          adminController.pickAndCropImage(
                              ImageSource.camera, context);
                          notify("success", "permision for storage is granted");
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
                      if (await adminController
                              .requestPermision(Permission.storage) ==
                          true) {
                        adminController.pickAndCropImage(
                            ImageSource.gallery, context);
                        notify("success", "permision for storage is granted");
                      } else {
                        notify("error", "permision for storage is not granted");
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
    getAllCategory();
  }

  getAllCategory() {
    adminController.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 182, 237, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Category",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(31, 18, 40, 136),
        foregroundColor: const Color.fromARGB(255, 18, 40, 136),
      ),
      body: GetBuilder<AdminController>(builder: (adminController) {
        return SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    controller: categoryController,
                    focusBorderColor: const Color.fromARGB(255, 18, 40, 136),
                    hintText: "Enter your Category",
                    errorBorderColor: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                adminController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 18, 40, 136),
                        ),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            fixedSize:
                                MaterialStatePropertyAll<Size>(Size(160, 20)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 18, 40, 136))),
                        onPressed: () {
                          adminController.addCategory(categoryController.text);
                          categoryController.clear();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_box, color: Colors.white),
                            Text(
                              "Add Category",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const Center(
                          child: Text(
                        'All Categories',
                        style: TextStyle(
                          color: Color.fromARGB(255, 18, 40, 136),
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                      DataTable(
                        headingRowColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 18, 40, 136)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                              label: Text('S.NO',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Category',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Action',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                        rows: List.generate(adminController.catList.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                                Text(adminController.catList[index]["name"])),
                            DataCell(Row(
                              children: [
                                adminController.catList[index]["status"]
                                    ? GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateCatStatus(index);
                                        },
                                        child: const Icon(
                                            Icons.check_box_outlined))
                                    : GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateCatStatus(index);
                                        },
                                        child: const Icon(Icons
                                            .check_box_outline_blank_outlined),
                                      ),
                                Text(adminController.catList[index]["status"]
                                    .toString()),
                              ],
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
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
                                                        Navigator.pop(context);
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
                                                        adminController
                                                            .deletCategory(
                                                                index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.delete)),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = index;
                                        editingController.text = adminController
                                            .catList[index]["name"]
                                            .toString();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          editingController,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color.fromARGB(255, 18, 40, 136))),
                                                      onPressed: () {
                                                        Navigator.pop(context);
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
                                                        adminController
                                                            .updateCatData(
                                                                index,
                                                                editingController
                                                                    .text);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ))
                          ]);
                        }),
                      ),
                    ])
              ],
            ),
          ),
        );
      }),
    );
  }
}
