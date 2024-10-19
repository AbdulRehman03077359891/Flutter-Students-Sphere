import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Widgets/notification_message.dart';

class AdminDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var cat = <Map<String, dynamic>>[].obs;
  var catCount = 0.obs;
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;
  var posts = <Map<String, dynamic>>[].obs;
  var postsCount = 0.obs;
  RxList<Map<String, dynamic>> selectedPosts = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }

  RxList categories = [
    'ScholarShips', 'Events', 'Career Guidance'
  ].obs;

    // Function to get dashboard data
  void getDashBoardData() {
    fetchUsers();
    fetchCategories();
    fetchRequests();
    fetchPosts();
  }
    // Function to fetch all users from the 'user' collection
  void fetchUsers() {
    try{
      setLoading(true);
    FirebaseFirestore.instance.collection("Student").snapshots().listen((QuerySnapshot snapshot) async {
      usersMap.clear();
      userCount.value = 0;

      try {
        for (var doc in snapshot.docs) {
          usersMap.add(doc.data() as Map<String, dynamic>);
          userCount.value = usersMap.length;
        }

      } catch (e) {
        print("Error fetching users: $e");
      }
    });
    }finally{
      setLoading(false);
    }
  }
  
  // Function to fetch all leave requests
  void fetchCategories() {
    try{
      setLoading(true);
    FirebaseFirestore.instance.collection("Category").where("status", isEqualTo: true).snapshots().listen((QuerySnapshot snapshot) {
      cat.clear();
      catCount.value = 0;

      for (var doc in snapshot.docs) {
        cat.add(doc.data() as Map<String, dynamic>);
        catCount.value = cat.length;
      }
    });
    }finally{
      setLoading(false);
    }
  }  

  // Function to fetch all leave requests
  void fetchRequests() {
    try{
      setLoading(true);
    FirebaseFirestore.instance.collection("Requests").snapshots().listen((QuerySnapshot snapshot) {
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
   Future<void> updateRequest(String reqKey, String status) async {
    try {
      setLoading(true);
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(reqKey)
          .update({"status" : status});
      notify('Success','Request updated successfully!');
    } catch (e) {
      notify('error','Error updating request: $e');
    }finally{
      setLoading(false);
    }
  }
  // Function to fetch all leave requests
  void fetchPosts() {
    try{
      setLoading(true);
    FirebaseFirestore.instance.collection("Posts")
    .snapshots().listen((QuerySnapshot snapshot) {
      posts.clear();
      postsCount.value = 0;

      for (var doc in snapshot.docs) {
        posts.add(doc.data() as Map<String, dynamic>);
        postsCount.value = posts.length;
      }
      // Count posts per category
    for (var category in cat) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Make sure data is not null
        if (data != null && data['catKey'] != null && category['catKey'] != null) {
          if (data['catKey'] == category['catKey']) {
            count++;
          }
        }
      }
      category['postCount'] = count; // Add post count to each category
    }

      update(); // Notify listeners
    });
    }finally{
      setLoading(false);
    }
  }

  // Get posts via Category
  Future<void> getPosts(int index,) async {
    try{
    setLoading(true);
    cat.refresh(); // To trigger UI updates

    if (cat[index]["catKey"] == "") {
      CollectionReference postInst = FirebaseFirestore.instance.collection("Posts");
      await postInst.get().then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedPosts.value = allPostsData;
      });
    } else {
      CollectionReference postsInst = FirebaseFirestore.instance.collection("Posts");
      await postsInst
          .where("catKey", isEqualTo: cat[index]["catKey"])
          .get()
          .then((QuerySnapshot data) {
        var allPostsData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedPosts.value = allPostsData;
      });
    }
    }finally{
      setLoading(false);
    }
  }




}