import 'package:flutter/material.dart';
import 'package:jutta_ghar/pages/admin_edit_page.dart';
import 'package:jutta_ghar/pages/admin_upload_page.dart';
import 'package:jutta_ghar/tiles/admin_product_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VendorAdminViewPage extends StatefulWidget {
  final adminRole;
  const VendorAdminViewPage({Key? key, this.adminRole}) : super(key: key);

  @override
  State<VendorAdminViewPage> createState() => _VendorAdminViewPageState();
}

class _VendorAdminViewPageState extends State<VendorAdminViewPage> {
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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: firestoreItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (firestoreItems[index]["brand_store"] ==
                            widget.adminRole) {
                          return Wrap(
                            children: [
                              AdminViewProductTile(
                                name: firestoreItems[index]["productName"],
                                description: firestoreItems[index]
                                    ["description"],
                                discount: firestoreItems[index]["discount"],
                                price:
                                    firestoreItems[index]["price"].toString(),
                                image: firestoreItems[index]["image"],
                                ontap: () {
                                  Get.to(
                                    () => AdminEditPage(
                                      productID: firestoreItems[index]
                                          ["productID"],
                                      brand_store_name: widget.adminRole,
                                      name: firestoreItems[index]
                                          ["productName"],
                                      description: firestoreItems[index]
                                          ["description"],
                                      discount: firestoreItems[index]
                                          ["discount"],
                                      price: firestoreItems[index]["price"]
                                          .toString(),
                                      image: firestoreItems[index]["image"],
                                      category: firestoreItems[index]
                                          ["category"],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
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
                    Get.to(() => AdminUploadPage(
                          brandUploadName: widget.adminRole,
                        ));
                  },
                  child: const Text("Add"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
