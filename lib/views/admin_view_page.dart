import 'package:flutter/material.dart';

import 'package:jutta_ghar/tiles/admin_product_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/views/admin_edit_page.dart';
import 'package:jutta_ghar/views/admin_upload_page.dart';

class AdminViewPage extends StatefulWidget {
  const AdminViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminViewPage> createState() => _AdminViewPageState();
}

class _AdminViewPageState extends State<AdminViewPage> {
  final user = FirebaseAuth.instance.currentUser;
  var searchKey = "";
  final clearSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 216, 216, 216),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              onChanged: ((value) {
                setState(() {
                  searchKey = value;
                });
              }),
              controller: clearSearchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 75, 75, 75),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      clearSearchController.clear();
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Color.fromARGB(255, 136, 136, 136),
                    ),
                  ),
                  hintText: 'Search Products...',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchKey != "")
                    ? FirebaseFirestore.instance
                        .collection('products')
                        .where("brand_store", isGreaterThanOrEqualTo: searchKey)
                        .where("brand_store", isLessThan: searchKey + 'z')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreItems =
                        snapshot.data!.docs;
                    return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: List.generate(
                          firestoreItems.length,
                          (index) => AdminViewProductTile(
                            name: firestoreItems[index]["productName"],
                            description: firestoreItems[index]["description"],
                            discount:
                                firestoreItems[index]["discount"].toString(),
                            price: firestoreItems[index]["price"].toString(),
                            image: firestoreItems[index]["image"],
                            offer: firestoreItems[index]["offer"],
                            ontap: () {
                              Get.to(
                                () => AdminEditPage(
                                  color: firestoreItems[index]["color"],
                                  productID: firestoreItems[index]["productID"],
                                  brand_store_name: firestoreItems[index]
                                      ["brand_store"],
                                  name: firestoreItems[index]["productName"],
                                  description: firestoreItems[index]
                                      ["description"],
                                  discount: firestoreItems[index]["discount"]
                                      .toString(),
                                  price:
                                      firestoreItems[index]["price"].toString(),
                                  image: firestoreItems[index]["image"],
                                  category: firestoreItems[index]["category"],
                                  offer: firestoreItems[index]["offer"],
                                  type: firestoreItems[index]["type"],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      Get.to(() => const AdminUploadPage(
                            brandUploadName: "",
                          ));
                    },
                    child: const Icon(Icons.add)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
