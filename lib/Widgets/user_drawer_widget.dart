import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/animation_controller.dart';
import 'package:studentsphere/Controllers/fire_controller.dart';
import 'package:studentsphere/Screens/Chat/choose_chat.dart';
import 'package:studentsphere/Screens/Student/personal_data.dart';
import 'package:studentsphere/Screens/Student/student_requests.dart';

class StudentDrawerWidget extends StatefulWidget {
  final String userUid, accountName, accountEmail;

  const StudentDrawerWidget({
    super.key,
    required this.userUid,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  State<StudentDrawerWidget> createState() => _StudentDrawerWidgetState();
}

class _StudentDrawerWidgetState extends State<StudentDrawerWidget> {
  final FireController fireController = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());

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
    return Obx(() {
      return Drawer(
        backgroundColor: const Color.fromARGB(255, 182, 237, 255),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 50,
        child: ListView(
          children: [
            fireController.isLoading.value
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .265,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 18, 40, 136),
                      ),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(31, 18, 40, 136)),
                    arrowColor: const Color.fromARGB(255, 18, 40, 136),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        if (fireController.userData["profilePic"] != null) {
                          animateController.showSecondPage(
                            "Profile Picture",
                            fireController.userData["profilePic"] ??
                                'assets/images/profilePlaceHolder.jpg',
                            context,
                          );
                        }
                      },
                      child: Hero(
                        tag: "Profile Picture",
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 18, 40, 136),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: const Color.fromARGB(31, 18, 40, 136),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            image: DecorationImage(
                              image: fireController.userData["profilePic"] !=
                                      null
                                  ? CachedNetworkImageProvider(
                                      fireController.userData["profilePic"])
                                  : const AssetImage(
                                          'assets/images/profilePlaceHolder.jpg')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    accountName: Text(
                      fireController.userData["userName"] ?? 'Unknown user',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(color: Colors.black87, blurRadius: 20)
                        ],
                      ),
                    ),
                    accountEmail: Text(
                      fireController.userData["userEmail"] ?? 'Unknown email',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          BoxShadow(color: Colors.black87, blurRadius: 20)
                        ],
                      ),
                    ),
                  ),
            _buildListTile(
              icon: Icons.person_rounded,
              title: "Personal Data",
              onTap: () {
                Get.to(
                  StudentPersonalData(
                    imageUrl: fireController.userData["profilePic"] ?? '',
                    userName: fireController.userData["userName"],
                    userUid: widget.userUid,
                    gender: fireController.userData["userGender"],
                    contact: fireController.userData["userContact"],
                    dob: fireController.userData["dateOfBirth"],
                    address: fireController.userData["userAddress"],
                    userEmail: fireController.userData["userEmail"],
                  ),
                );
              },
            ),
            _buildListTile(
              icon: Icons.request_page,
              title: "Requests",
              onTap: () {
                Get.to(StudentsRequests(
                    userUid: widget.userUid,
                    userName: fireController.userData["userName"],
                    userEmail: fireController.userData["userEmail"]));
              },
            ),
            _buildListTile(
              icon: Icons.chat,
              title: "Chats",
              onTap: () { Get.to(ChatsScreen(
                  userUid: fireController.userData["userUid"],
                  userName: fireController.userData["userName"],
                  userEmail: fireController.userData["userEmail"],
                  status: false,
                  profilePicture: fireController.userData["profilePic"],
                ));},
            ),
            _buildListTile(
              icon: Icons.logout,
              title: "LogOut",
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text(
                            "Are you sure?",
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: [
                            ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 18, 40, 136))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 18, 40, 136))),
                                onPressed: () {
                                  fireController.logOut();
                                },
                                child: const Text(
                                  "Log out",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ));
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 18, 40, 136),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 18, 40, 136)),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromARGB(255, 18, 40, 136),
      ),
      onTap: onTap,
    );
  }
}
