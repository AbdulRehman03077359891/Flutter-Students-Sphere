import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studentsphere/Screens/Admin/admin_dashboard.dart';
import 'package:studentsphere/Widgets/notification_message.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusinessController extends GetxController {
  bool isLoading = false;
  var allCategories = [];
  var dropDownValue = "";
  var selectDropDownKey = "";
  late String _imageLink = '';
  final pickedImageFile = Rx<File?>(null);
  var selectedPosts = [];
  var allOrders = [];
  RxList pendingOrders = [].obs;
  List acceptedOrders = [];
  List shippedOrders = [];
  List deliveredOrders = [];
  List cancelledOrders = [];
  RxInt postsCount = 0.obs;
  RxList alOrders = [].obs;
  RxInt pOrders = 0.obs;
  RxInt aOrders = 0.obs;
  RxInt sOrders = 0.obs;
  RxInt dOrders = 0.obs;
  RxInt cOrders = 0.obs;
  var selectedPost = {}.obs;


// Setting Loading when processing ----------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }

// getting Category Data --------------------------------------------------
  getCategory(userUid) async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allCategories = data.docs.map((doc) => doc.data()).toList();
      // var newData = {
      //   "catKey": "",
      //   "name": "All",
      //   "status": true,
      //   "imageUrl": "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e",
      //   "selected" : false,
      // };
      // allCategories = allCategories;
      // allCategories.insert(0, newData);
      getPosts(0, userUid);
    });
    setLoading(false);
    update();
  }

// Setting Drop Down Value ------------------------------------------------
  setDropDownValue(value) {
    dropDownValue = value["name"];
    selectDropDownKey = value["catKey"];
    update();
  }

// Check if we are good to go to add Posts ---------------------------------
  addPost(postName, date, link, discription, userUid, userName, userEmail, profilePicture) {
    if (postName.isEmpty) {
      notify("error", "Please Enter PostsName");
    } else if (discription.isEmpty) {
      notify("error", "Please Enter Discriiption");
    } else if (dropDownValue == "") {
      notify("error", "Please Enter Category");
    } else if (date.isEmpty) {
      notify("error", "Please Enter Price");
    } else {
      imageStoreStorage(postName, date, link, discription, userUid, userName, userEmail, profilePicture );
    }
  }

//Storing Posts Image -----------------------------------------------
  imageStoreStorage(postName, date, link, discription,userUid, userName, userEmail, profilePicture) async {
    try {
      setLoading(true);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("post/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      update();
      fireStoreDBase(postName, date, link, discription,userUid, userName, userEmail, profilePicture);
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
      update();
    }
  }


// Adding Posts ----------------------------------------------------------
  fireStoreDBase(postName, date, link, discription, userUid, userName, userEmail, profilePicture) async {
    try {
      CollectionReference postsInst =
          FirebaseFirestore.instance.collection("Posts");
      var postKey = FirebaseDatabase.instance.ref("Category").push().key;

      var postObj = {
        "postName": postName,
        "category": dropDownValue,
        "catKey": selectDropDownKey,
        "postPic": _imageLink,
        "postLink": link,
        "date": date,
        "postKey": postKey,
        "userUid" : userUid,
        "userName" : userName,
        "userEmail" : userEmail,
        "profilePicture" : profilePicture,
        "discription" : discription,
      };

      await postsInst.doc(postKey).set(postObj);

      notify('Success', 'Post Added Successfully');

      setLoading(false);
      dropDownValue = "";
      selectDropDownKey = "";
      pickedImageFile.value = null;
      update();
    } catch (e) {
      setLoading(false);
      notify("error", "Database ${e.toString()}");
      update();
    }
  }

// Deleting Dish =========
  deletPost(postKey, userUid, userName, userEmail) async {
    CollectionReference postInst = FirebaseFirestore.instance.collection("Posts");
    await postInst.doc(postKey).delete();
    // selectedAmbulances.removeAt(index);
    update();
    Get.off(AdminDashboard(userUid: userUid, userName: userName, userEmail: userEmail));
  }

  Future<void> getPostData(String postKey) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection("Posts").doc(postKey).get();
      selectedPost.value = document.data() as Map<String, dynamic>;
    } catch (e) {
      notify("error", "Failed to retrieve post data: ${e.toString()}");
    }
  }

  updatePost(String postKey, String postName, String description, String date, userUid, userName, userEmail) async {
  try {
    CollectionReference postsRef = FirebaseFirestore.instance.collection("Posts");
    await postsRef.doc(postKey).update({
      "postName": postName,
      "discription": description,
      "date": date,
    });
    notify("success", "Post updated successfully!");
    Get.off(AdminDashboard(userUid: userUid, userName: userName, userEmail: userEmail,));
  } catch (e) {
    notify("error", "Failed to update post: ${e.toString()}");
  }
}

// Get Posts via Category==========
  getPosts(index,userUid) async {
    for(int i = 0; i <allCategories.length; i++){
      allCategories[i]["selected"] = false;
    }
    allCategories[index]["selected"] = true;
    if (allCategories[index]["catKey"] == "") {
      CollectionReference postInst =
          FirebaseFirestore.instance.collection("Posts");
      await postInst
          .where("userUid", isEqualTo: userUid)
          .get()
          .then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data()).toList();

        selectedPosts = allPostsData;
        update();});
      } else {
      CollectionReference postsInst =
          FirebaseFirestore.instance.collection("Posts");
      await postsInst
          .where("catKey", isEqualTo: allCategories[index]["catKey"]).where("userUid", isEqualTo: userUid)
          .get()
          .then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data()).toList();

        selectedPosts = allPostsData;
        update();
      });
    }
  }

// Taking Permission from Phone ==============================
  Future<bool> requestPermision(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

// Getting posts Image via Gallery/Camera =========================== 
  Future<void> pickAndCropImage(ImageSource source, context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          pickedImageFile.value = croppedFile;
          update();
        }else {
        notify("error", "Image cropping was canceled or failed.");
      }
    } else {
      notify("error", "Image picking was canceled.");
    }
      
    } catch (e) {
      notify("error", "Failed to pick or crop image: $e");
    }
    finally{
      Navigator.pop(context);
    }
  }

// Cropping Image ================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),

        uiSettings: [
          AndroidUiSettings(
            
            toolbarTitle: "Image Cropper",
            toolbarColor: const Color.fromARGB(255, 18, 40, 136),            toolbarWidgetColor: Colors.white,
            // initAspectRatio: CropAspectRatioPreset.ratio3x4,
            lockAspectRatio: true,
            hideBottomControls: true
          ),
          IOSUiSettings(
            title: "Image Cropper",
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
      notify("error", "No image was cropped.");
      return null;
      }
    } catch (e) {
      notify("error", "Failed to crop image: $e");
    }
    return null;
  }

  
  getOrder(String nUserUid) async {
    setLoading(true);
  // Clear previous data
  allOrders.clear();
  pendingOrders.clear();
  acceptedOrders.clear();
  shippedOrders.clear();
  deliveredOrders.clear();
  cancelledOrders.clear();

  update();

  CollectionReference orderInst = FirebaseFirestore.instance.collection("Orders");

  // Fetch orders based on user UID
   orderInst.where("bUserUid", isEqualTo: nUserUid).snapshots().listen((QuerySnapshot data) {
    var ordersData = data.docs.map((doc) => doc.data()).toList();

    // Loop through each order and categorize it by its status
    for (var order in ordersData) {
      // Check if order is not null and status exists
      if (order != null && order is Map<String, dynamic> && order.containsKey('status')) {
        String? status = order['status'] as String?;

        // Switch based on status
        switch (status) {
          case "pending":
            pendingOrders.add(order);
            break;
          case "accepted":
            acceptedOrders.add(order);
            break;
          case "shipped":
            shippedOrders.add(order);
            break;
          case "delivered":
            deliveredOrders.add(order);
            break;
          case "cancelled":
            cancelledOrders.add(order);
            break;
          default:
            // Handle unknown or missing status
            allOrders.add(order);
        }
      } else {
        // Handle cases where order or status is null
        allOrders.add(order);  // Optionally add the order to a general list
      }
    }

    // Update with categorized orders
    allOrders = ordersData;  // If you want to keep all orders in one list as well
    setLoading(false);
    update();
  });
  
}
Future<void> openMap(String lat, String long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    try {
      await launchUrlString(googleUrl);
    } catch (e) {
      notify("error", 'Error launching URL: $e');
      // Optionally, show an error message to the user
    }
  }

  updateOrder(orderKey,status,reason) async {
    setLoading(true);
      CollectionReference orderInst = FirebaseFirestore.instance.collection("Orders");

    var doc = await orderInst.doc(orderKey).get();

    if (doc.exists) {
      await orderInst.doc(orderKey).update({
        "status": status,
        "reason": reason
      }).then((_) {
        setLoading(false);
        update();
        notify("Success", "Order updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update status: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
  }
getDashBoardData(bUserUid) {
    // Listen to Posts collection
    FirebaseFirestore.instance.collection("Posts").snapshots().listen((QuerySnapshot data) {
      notify("Fetched Posts: ", "${data.docs.length}");
      postsCount.value = data.docs.length;
    });

    // Listen to Orders and categorize them
    FirebaseFirestore.instance.collection("Orders").where("bUserUid", isEqualTo: bUserUid).snapshots().listen((QuerySnapshot data) {
      var ordersData = data.docs.map((doc) => doc.data()).toList();

      // Reset counts for each order status
      pOrders.value = 0;
      aOrders.value = 0;
      sOrders.value = 0;
      dOrders.value = 0;
      cOrders.value = 0;
      allOrders.clear();

      // Loop through each order and categorize it by its status
      for (var order in ordersData) {
        // Check if order is not null and status exists
        if (order != null && order is Map<String, dynamic> && order.containsKey('status')) {
          String? status = order['status'] as String?;

          // Increment the respective order count based on status
          switch (status) {
            case "pending":
              pOrders.value++;
              break;
            case "accepted":
              aOrders.value++;
              break;
            case "shipped":
              sOrders.value++;
              break;
            case "delivered":
              dOrders.value++;
              break;
            case "cancelled":
              cOrders.value++;
              break;
            default:
              alOrders.add(order); // Add to general list if uncategorized
          }
        } else {
          // Handle cases where order or status is null
          alOrders.add(order);  // Optionally add the order to a general list
        }
      }

      // Update with categorized orders and notify UI
      setLoading(false);
      update();
    });
  }

}