// import 'package:get/get.dart';
// import 'package:jutta_ghar/models/product.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProductController extends GetxController {
//   var productList = <Product>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   //Get data from firebase
//   Stream<List<Product>> getAllProducts() {
//     return FirebaseFirestore.instance.collection("products").snapshots().map(
//         (query) =>
//             query.docs.map((item) => Product.fromJson(item.data())).toList());
//   }

//   void fetchProducts() async {
//     productList.value = [getAllProducts()];
//   }
// }
