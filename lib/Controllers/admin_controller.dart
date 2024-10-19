import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:studentsphere/Widgets/notification_message.dart';

class AdminController extends GetxController {
  var isLoading = true;
  var catList = [];
  final pickedImageFile = Rx<File?>(null);
  var allCategories = [];
  var selectedPosts = [];


// Setting Loading ---------------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }
// Category Settings -------------------------------------------------------

// Get Data================
  getCategoryList() async {
    setLoading(true);
    catList.clear();
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.get().then((QuerySnapshot data) {
      for (var element in data.docs) {
        catList.add(element.data());
      }
    });
    setLoading(false);
    update();
  }

  getCategory() async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allCategories = data.docs.map((doc) => doc.data()).toList();
      var newData = {
        "catKey": "",
        "name": "All",
        "status": true,
        "imageUrl": "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e",
        "selected" : false,
      };
      allCategories = allCategories;
      allCategories.insert(0, newData);
      getPosts(0);
    });
    setLoading(false);
    update();
  }

// Get Post via Category==========
  getPosts(index) async {
    try{
      setLoading(true);
    for(int i = 0; i <allCategories.length; i++){
      allCategories[i]["selected"] = false;
    }
    allCategories[index]["selected"] = true;
    if (allCategories[index]["catKey"] == "") {
      CollectionReference postsInst =
          FirebaseFirestore.instance.collection("Posts");
      await postsInst
          .get()
          .then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data()).toList();

        selectedPosts = allPostsData;
        update();});
      } else {
      CollectionReference postsInst =
          FirebaseFirestore.instance.collection("Posts");
      await postsInst
          .where("catKey", isEqualTo: allCategories[index]["catKey"])
          .get()
          .then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data()).toList();

        selectedPosts = allPostsData;
        update();
      });
    }
    }finally{
      setLoading(false);
    }
  }
// Delete Posts
   deletPosts(index) async {
    try{
      setLoading(true);
    CollectionReference postsInst = FirebaseFirestore.instance.collection("Posts");
    await postsInst.doc(selectedPosts[index]["postKey"]).delete();
    selectedPosts.removeAt(index);
    update();
    }finally{
      setLoading(false);
    }
  }


// Delete Category============
  deletCategory(index) async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst.doc(catList[index]["catKey"]).delete();
    catList.removeAt(index);
    setLoading(false);
    update();
  }

// Update Category Status=======
  updateCatStatus(index) async {
    setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    await categoryInst
        .doc(catList[index]["catKey"])
        .update({"status": !catList[index]["status"]});
    catList[index]["status"] = !catList[index]["status"];
    setLoading(false);
    update();
  }

// Update Category Data=============
  updateCatData(index, name) async {
    setLoading(true);
    if (name.isEmpty) {
      notify("error", "Please enter a valid name");
      return;
    }
    try {
      updateCategory(index, name);
      update();
      
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
    }
    

    
  }
  updateCategory(index,name) async {
    try{
      setLoading(true);
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");

    var docKey = catList[index]["catKey"];
    var doc = await categoryInst.doc(docKey).get();

    if (doc.exists) {
      await categoryInst.doc(docKey).update({
        "name": name,
      }).then((_) {
        getCategoryList();
        pickedImageFile.value = null;
        setLoading(false);
        update();
        notify("Success", "Category updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update name: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
    }finally{
      setLoading(false);
    }
  }
// Adding New Category======
  addCategory(String name) {
    setLoading(true);
    if (name.isEmpty) {
      notify("error", "Please enter Category");
    } else {
      fireStoreDBase(name);
    }
  }


// Storing New Category Data in Firebase Data Base===
  fireStoreDBase(name) async {
    CollectionReference categoryInst =
        FirebaseFirestore.instance.collection("Category");
    var key = FirebaseDatabase.instance.ref("Category").push().key;
    var categoryObj = {
      "name": name,
      "status": true,
      "catKey": key,
      "selected": false,  
    };
    await categoryInst.doc(key).set(categoryObj);
    notify("Success", "Category added Successfully");
    pickedImageFile.value = null ;
    getCategoryList();
    setLoading(false);
    update();
  }

// Taking permission to from Mobile ==========================
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

// Taking Category Picture from Camera/Storage =====================
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
// Cropping Image=================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,

        uiSettings: [
          AndroidUiSettings(
            
            toolbarTitle: "Image Cropper",
            toolbarColor: const Color.fromARGB(255, 111, 2, 43),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
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
  

}
