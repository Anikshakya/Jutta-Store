// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BrandPage extends StatefulWidget {
  final brandName;
  const BrandPage({Key? key, this.brandName}) : super(key: key);

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final user = FirebaseAuth.instance.currentUser;
  var searchKey = "";
  final clearSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.brandName.toUpperCase(),
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: StreamBuilder<QuerySnapshot>(
                  stream: (searchKey != "")
                      ? FirebaseFirestore.instance
                          .collection('products')
                          .where("productName",
                              isGreaterThanOrEqualTo: searchKey)
                          .where("productName", isLessThan: searchKey + 'z')
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
                      List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                          snapshot.data!.docs;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: List.generate(
                            firestoreProducts.length,
                            (index) => firestoreProducts[index]
                                        ['brand_store'] ==
                                    widget.brandName
                                ? ProductTile(
                                    name: firestoreProducts[index]
                                        ["productName"],
                                    description: firestoreProducts[index]
                                        ["description"],
                                    discount: firestoreProducts[index]
                                            ["discount"]
                                        .toString(),
                                    price: firestoreProducts[index]["price"]
                                        .toString(),
                                    image: firestoreProducts[index]["image"],
                                    ontap: () => Get.to(
                                      () => OrderPage(
                                        image: firestoreProducts[index]
                                            ['image'],
                                        price: firestoreProducts[index]
                                            ['price'],
                                        name: firestoreProducts[index]
                                            ['productName'],
                                        brand: firestoreProducts[index]
                                                ['brand_store']
                                            .toUpperCase(),
                                        description: firestoreProducts[index]
                                            ["description"],
                                        discount: firestoreProducts[index]
                                                ['discount']
                                            .toString(),
                                        category: firestoreProducts[index]
                                            ['category'],
                                        offer: firestoreProducts[index]
                                            ['offer'],
                                        productID: firestoreProducts[index]
                                            ['productID'],
                                        type: firestoreProducts[index]['type'],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
