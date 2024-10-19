import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studentsphere/Screens/Student/user_screen.dart';
import 'package:studentsphere/Widgets/notification_message.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudentController extends GetxController{
  RxBool isLoading = false.obs;
  
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;

  setLoading(val){
    isLoading.value = val;
  }

  formRequest(studentUid, studentName, studentEmail, studentPic, studentContact, studentCnic, studentGender, studentQualification, postKey, postPic) async {
    try{
      setLoading(true);
    CollectionReference reqIns = FirebaseFirestore.instance.collection("Requests");
    var reqKey = FirebaseDatabase.instance.ref("Requests").push().key;

    var reqObj = {
      "studentUid" : studentUid,
      "studentName" : studentName,
      "studentEmail" : studentEmail,
      "studentPic" : studentPic,
      "studentContact" : studentContact,
      "studentCnic" : studentCnic,
      "studentGender" : studentGender,
      "studentQualification" : studentQualification,
      "postKey" : postKey,
      "postPic" : postPic,
      "status" : "pending",
      "appliedAt" : DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      "reqKey" : reqKey
    };

    await reqIns.doc(reqKey).set(reqObj);

    Get.off(StudentScreen(userUid: studentUid, userName: studentName, userEmail: studentEmail));
    }finally{
      setLoading(false);
    }
  }

    // Function to fetch all leave requests
  void fetchRequests(userUid) {
    try{
      setLoading(true);
    FirebaseFirestore.instance.collection("Requests").where("studentUid", isEqualTo: userUid).snapshots().listen((QuerySnapshot snapshot) {
      req.clear();
      reqCount.value = 0;

      for (var doc in snapshot.docs) {
        req.add(doc.data() as Map<String, dynamic>);
        reqCount.value = req.length;
      }
    });
    }finally{
      setLoading(false);
    }
  }

  openLink(postLink) async {
    try {
      await launchUrlString(postLink);
    } catch (e) {
      notify("error", 'Error launching URL: $e');
      // Optionally, show an error message to the user
    }
  }


}