import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Controllers/admin_dashboard_controller.dart';
import 'package:studentsphere/Controllers/admin_notfication_sevices.dart';
import 'package:studentsphere/Screens/Admin/admin_posts_categorized.dart';
import 'package:studentsphere/Widgets/admin_drawer_widget.dart';

class AdminDashboard extends StatefulWidget {
  final String userUid, userName, userEmail;
  const AdminDashboard({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      adminDashboardController.getDashBoardData();
      notificationServices.requestNotificationPermissions(context);
      notificationServices.firebaseInit(context);
      notificationServices.setupInteractMessage(context);
      notificationServices.getDeviceToken().then((token) {
        if (token.isNotEmpty) {
      notificationServices.storeAdminFCMToken(widget.userUid, token);
    }
    // Start listening for new requests and trigger notifications
    notificationServices.listenForNewRequests(widget.userUid);
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
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
              shadows: [BoxShadow(blurRadius: 10, spreadRadius: 20)],
            ),
          ),
        ],
      ),
    ),
    drawer: AdminDrawerWidget(
      userUid: widget.userUid,
      accountName: widget.userName,
      accountEmail: widget.userEmail,
    ),
    body: Obx(
      () {
        if (adminDashboardController.cat.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
            ),
            itemCount: adminDashboardController.cat.length,
            itemBuilder: (context, index) {
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
                          Get.to(PostsViaCategory(
                            userUid: widget.userUid,
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            index: index,
                          ));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              adminDashboardController.cat[index]["name"],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 18, 40, 136),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(blurRadius: 2, spreadRadius: 2),
                                ],
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${adminDashboardController.cat[index]["postCount"] ?? 0} Posts',
                              style:  TextStyle(
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
          );
        }
      },
    ),
  );
  }
}

