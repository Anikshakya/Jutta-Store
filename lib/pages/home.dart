// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/pages/admin_view_page.dart';
import 'package:jutta_ghar/pages/cart.dart';
import 'package:jutta_ghar/pages/live_preview_test.dart';
import 'package:jutta_ghar/pages/order_page.dart';
import 'package:jutta_ghar/pages/search_page.dart';
import 'package:jutta_ghar/pages/story.dart';
import 'package:jutta_ghar/pages/story2.dart';
import 'package:jutta_ghar/pages/wishlist.dart';
import 'package:jutta_ghar/tiles/circular_story_tile.dart';
import 'package:jutta_ghar/tiles/horizontal_product_tile.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/pages/superadmin_user_view_page.dart';
import 'package:jutta_ghar/pages/vendor_admin_view_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  bool _loadItemsCount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () => Get.to(() => Wishlist()),
                child: Icon(Icons.favorite_border_rounded)),
            Spacer(),
            Text(
              "Jutta Ghar",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(Icons.person),
          ),
          GestureDetector(
            onTap: () => Get.to(() => SearchPage()),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Icon(Icons.search_rounded),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => Cart()),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Row(
          children: [
            Drawer(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          iconColor: Colors.black,
                          leading: Icon(Icons.insert_emoticon),
                          title: Text(
                            'Mens',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: ListTile(
                            iconColor: Colors.black,
                            leading: Icon(Icons.exit_to_app_rounded),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        itemBuilder: ((context, index) => CircularStoryTile(
                              index: index,
                              onTapAddStory: () {
                                pickImage(ImageSource.camera);
                              },
                              onTapStory: () => Get.to(() => Story()),
                            ))),
                  ),
                  //Offer Section
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Offers"),
                        Text("View More"),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where("offer", isEqualTo: "Yes")
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                            snapshot.data!.docs;
                        return AspectRatio(
                          aspectRatio: 1.24,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: firestoreProducts.length,
                            itemBuilder: (context, index) =>
                                HorizontalProductTile(
                              name: firestoreProducts[index]["productName"],
                              description: firestoreProducts[index]
                                  ["description"],
                              discount: firestoreProducts[index]["discount"]
                                  .toString(),
                              price:
                                  firestoreProducts[index]["price"].toString(),
                              image: firestoreProducts[index]["image"],
                              ontap: () => Get.to(
                                () => OrderPage(
                                  url: firestoreProducts[index]['image'],
                                  price: firestoreProducts[index]['price'],
                                  title: firestoreProducts[index]
                                      ['productName'],
                                  desc: firestoreProducts[index]['description'],
                                  discount: firestoreProducts[index]['discount']
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  //custom offers
                  //Offer Section
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("World Cup Offer"),
                        Text("View More"),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where("category", isEqualTo: "Football Shoes")
                        .where("offer", isEqualTo: "Yes")
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                            snapshot.data!.docs;
                        return AspectRatio(
                          aspectRatio: 1.24,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: firestoreProducts.length,
                            itemBuilder: (context, index) =>
                                HorizontalProductTile(
                              name: firestoreProducts[index]["productName"],
                              description: firestoreProducts[index]
                                  ["description"],
                              discount: firestoreProducts[index]["discount"]
                                  .toString(),
                              price:
                                  firestoreProducts[index]["price"].toString(),
                              image: firestoreProducts[index]["image"],
                              ontap: () => Get.to(
                                () => OrderPage(
                                  url: firestoreProducts[index]['image'],
                                  price: firestoreProducts[index]['price'],
                                  title: firestoreProducts[index]
                                      ['productName'],
                                  desc: firestoreProducts[index]['description'],
                                  discount: firestoreProducts[index]['discount']
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  //All  Products Section
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Text("Products"),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                            snapshot.data!.docs;
                        return Wrap(
                          children: List.generate(
                            _loadItemsCount == false
                                ? 5
                                : firestoreProducts.length,
                            (index) => ProductTile(
                              name: firestoreProducts[index]["productName"],
                              description: firestoreProducts[index]
                                  ["description"],
                              discount: firestoreProducts[index]["discount"]
                                  .toString(),
                              price:
                                  firestoreProducts[index]["price"].toString(),
                              image: firestoreProducts[index]["image"],
                              ontap: () => Get.to(
                                () => OrderPage(
                                  url: firestoreProducts[index]['image'],
                                  price: firestoreProducts[index]['price'],
                                  title: firestoreProducts[index]
                                      ['productName'],
                                  desc: firestoreProducts[index]['description'],
                                  discount: firestoreProducts[index]['discount']
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        _loadItemsCount = !_loadItemsCount;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                          child: _loadItemsCount == false
                              ? Text("View All")
                              : Text("Show Less")),
                    ),
                  ),
                ],
              ),
            ),

            //admin section
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 25, top: 25),
              child: Align(
                alignment: Alignment.bottomRight,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: user!.email)
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
                      return firestoreItems[0]["role"] == "vendor"
                          ? FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: () {
                                Get.to(
                                  () => VendorAdminViewPage(
                                    adminRole: firestoreItems[0]["admin_role"]
                                        .toString(),
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit_note_rounded),
                            )
                          : firestoreItems[0]["role"] == "superAdmin"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: "btn2",
                                      onPressed: () =>
                                          Get.to(SuperAdminUserViewPage()),
                                      child: const Icon(Icons.person),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FloatingActionButton(
                                      heroTag: "btn3",
                                      onPressed: () {
                                        Get.to(() => const AdminViewPage());
                                      },
                                      child:
                                          const Icon(Icons.edit_note_rounded),
                                    ),
                                  ],
                                )
                              : const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //pick image
  File? _imageFile;
  final box = GetStorage();
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        _imageFile =
            File(image.path); //saves image in a file and files location
        box.write(
            "a", _imageFile); //saves image path location to box storage "a"
      });
    } on Exception catch (e) {
      // ignore: avoid_print
      print("Failed to pick image: $e");
    }
  }
}


//  Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Expanded(
            //       flex: 3,
            //       child: Column(
            //         children: [
            //           SizedBox(
            //             height: 40,
            //             child: Center(
            //               child: Text("All"),
            //             ),
            //           ),
            //           Container(
            //             margin: EdgeInsets.only(left: 10, right: 10),
            //             height: 2,
            //             color: Colors.black,
            //           )
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       flex: 3,
            //       child: Column(
            //         children: [
            //           SizedBox(
            //             height: 40,
            //             child: Center(
            //               child: Text("Addidas"),
            //             ),
            //           ),
            //           Container(
            //             margin: EdgeInsets.only(left: 10, right: 10),
            //             height: 2,
            //             color: Colors.black,
            //           )
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       flex: 3,
            //       child: Column(
            //         children: [
            //           SizedBox(
            //             height: 40,
            //             child: Center(
            //               child: Text("Nike"),
            //             ),
            //           ),
            //           Container(
            //             margin: EdgeInsets.only(left: 10, right: 10),
            //             height: 2,
            //             color: Colors.black,
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
