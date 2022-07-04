import 'package:flutter/material.dart';
import 'package:jutta_ghar/pages/admin_edit_page.dart';
import 'package:jutta_ghar/pages/admin_upload_page.dart';
import 'package:jutta_ghar/tiles/admin_product_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminViewPage extends StatefulWidget {
  const AdminViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminViewPage> createState() => _AdminViewPageState();
}

class _AdminViewPageState extends State<AdminViewPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  List<QueryDocumentSnapshot<Object?>> firestoreItems =
                      snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: firestoreItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Wrap(
                        children: [
                          AdminViewProductTile(
                            name: firestoreItems[index]["productName"],
                            description: firestoreItems[index]["description"],
                            discount: firestoreItems[index]["discount"],
                            price: firestoreItems[index]["price"].toString(),
                            image: firestoreItems[index]["image"],
                            ontap: () {
                              Get.to(
                                () => AdminEditPage(
                                  productID: firestoreItems[index]["productID"],
                                  brand_store_name: firestoreItems[index]
                                      ["brand_store"],
                                  name: firestoreItems[index]["productName"],
                                  description: firestoreItems[index]
                                      ["description"],
                                  discount: firestoreItems[index]["discount"],
                                  price:
                                      firestoreItems[index]["price"].toString(),
                                  image: firestoreItems[index]["image"],
                                  category: firestoreItems[index]["category"],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: FloatingActionButton(
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
