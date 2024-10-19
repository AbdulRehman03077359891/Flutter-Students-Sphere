import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StudentDashboardController extends GetxController{
  var isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var cat = <Map<String, dynamic>>[].obs;
  var catCount = 0.obs;
  var posts = <Map<String, dynamic>>[].obs;
  var postsCount = 0.obs;
  RxList<Map<String, dynamic>> selectedPosts = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }

    // Function to get dashboard data
  void getDashBoardData() {
    fetchCategories();
    fetchPosts();
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

  // Get Posts via Category
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
      CollectionReference postInst = FirebaseFirestore.instance.collection("Posts");
      await postInst
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