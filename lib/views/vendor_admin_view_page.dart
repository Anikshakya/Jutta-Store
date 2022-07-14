// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:jutta_ghar/views/admin_edit_page.dart';
import 'package:jutta_ghar/views/admin_upload_page.dart';
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
                        .where("productName", isGreaterThanOrEqualTo: searchKey)
                        .where("productName", isLessThan: searchKey + 'z')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreItems =
                        snapshot.data!.docs;
                    return Wrap(
                      children: List.generate(
                          firestoreItems.length,
                          (index) => firestoreItems[index]["brand_store"] ==
                                  widget.adminRole
                              ? AdminViewProductTile(
                                  offer: firestoreItems[index]["offer"],
                                  name: firestoreItems[index]["productName"],
                                  description: firestoreItems[index]
                                      ["description"],
                                  discount: firestoreItems[index]["discount"]
                                      .toString(),
                                  price:
                                      firestoreItems[index]["price"].toString(),
                                  image: firestoreItems[index]["image"],
                                  ontap: () {
                                    Get.to(
                                      () => AdminEditPage(
                                        offer: firestoreItems[index]["offer"],
                                        type: firestoreItems[index]["type"],
                                        productID: firestoreItems[index]
                                            ["productID"],
                                        brand_store_name: widget.adminRole,
                                        name: firestoreItems[index]
                                            ["productName"],
                                        description: firestoreItems[index]
                                            ["description"],
                                        discount: firestoreItems[index]
                                                ["discount"]
                                            .toString(),
                                        price: firestoreItems[index]["price"]
                                            .toString(),
                                        image: firestoreItems[index]["image"],
                                        category: firestoreItems[index]
                                            ["category"],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox()),
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Get.to(() => AdminUploadPage(
                          brandUploadName: widget.adminRole,
                        ));
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
