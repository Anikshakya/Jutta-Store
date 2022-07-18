// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/category/category_button.dart';
import 'package:jutta_ghar/category/category_list.dart';
import 'package:jutta_ghar/tiles/brand_tile.dart';
import 'package:jutta_ghar/tiles/offer_tile.dart';
import 'package:jutta_ghar/tiles/test_tile.dart';
import 'package:jutta_ghar/views/admin_view_page.dart';
import 'package:jutta_ghar/views/brand_list_page.dart';
import 'package:jutta_ghar/views/brand_page.dart';
import 'package:jutta_ghar/views/color_view.dart';
import 'package:jutta_ghar/views/offer_page.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:jutta_ghar/views/search_page.dart';
import 'package:jutta_ghar/views/wishlist.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/views/superadmin_user_view_page.dart';
import 'package:jutta_ghar/views/vendor_admin_view_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_count_down/date_count_down.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _categoryName = "All".obs;

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
              child: Stack(
                children: [
                  Icon(Icons.favorite_border_rounded),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("wishlist")
                        .doc(user!.email)
                        .collection("products")
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      } else {
                        List<QueryDocumentSnapshot<Object?>>
                            firestoreWishlistData = snapshot.data!.docs;
                        return Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Container(
                            height: 17,
                            width: 17,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 217, 193),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                firestoreWishlistData.length.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                "JUTTA GHAR",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => SearchPage()),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(Icons.search_rounded),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => ColorView()),
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Icon(Icons.color_lens_outlined)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Icon(Icons.message_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image Carsouel
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("banner_image")
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<QueryDocumentSnapshot<Object?>>
                              firestoreBannerImage = snapshot.data!.docs;
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: CarouselSlider.builder(
                                unlimitedMode: true,
                                itemCount: firestoreBannerImage.length,
                                enableAutoSlider: true,
                                autoSliderDelay: Duration(seconds: 3),
                                autoSliderTransitionTime:
                                    Duration(milliseconds: 500),
                                slideIndicator: CircularSlideIndicator(
                                    itemSpacing: 15.0,
                                    indicatorBackgroundColor:
                                        Color.fromARGB(95, 197, 197, 197),
                                    currentIndicatorColor: Colors.white,
                                    padding: EdgeInsets.only(bottom: 10)),
                                slideBuilder: (index) {
                                  return CachedNetworkImage(
                                    imageUrl: firestoreBannerImage[index]
                                        ["image"],
                                    fit: BoxFit.cover,
                                  );
                                }),
                          );
                        }
                      })),

                  //Offer Section
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 16, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OFFERS",
                          style: TextStyle(
                              letterSpacing: 0.4,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              "Ends In: ",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            CountDownText(
                              due: DateTime.parse("2022-08-20 00:00:00"),
                              finishedText: "Ended",
                              showLabel: true,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => OfferPage()),
                          child: Row(
                            children: const [
                              Text(
                                "View More",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.5,
                              )
                            ],
                          ),
                        ),
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
                        return SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: firestoreProducts.length,
                            itemBuilder: (context, index) => OfferTile(
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
                                  image: firestoreProducts[index]['image'],
                                  price: firestoreProducts[index]['price'],
                                  name: firestoreProducts[index]['productName'],
                                  brand: firestoreProducts[index]['brand_store']
                                      .toUpperCase(),
                                  description: firestoreProducts[index]
                                      ["description"],
                                  discount: firestoreProducts[index]['discount']
                                      .toString(),
                                  category: firestoreProducts[index]
                                      ['category'],
                                  offer: firestoreProducts[index]['offer'],
                                  productID: firestoreProducts[index]
                                      ['productID'],
                                  type: firestoreProducts[index]['type'],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  //Brands Section
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 15, top: 16, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("OUR BRAND PARTNERS",
                            style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        GestureDetector(
                          onTap: () => Get.to(() => BrandLists()),
                          child: Row(
                            children: const [
                              Text(
                                "View More",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('brand')
                        .orderBy("brand_name", descending: true)
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
                        return SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: firestoreProducts.length,
                            itemBuilder: (context, index) => BrandTile(
                              brandName: firestoreProducts[index]["brand_name"],
                              image: firestoreProducts[index]['logo'],
                              ontap: () => Get.to(BrandPage(
                                brandName: firestoreProducts[index]
                                    ['brand_name'],
                              )),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  // //test
                  // SizedBox(
                  //   height: 20,
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 15, right: 15, top: 10, bottom: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: const [
                  //       Text("Product Model"),
                  //       Text("View More"),
                  //     ],
                  //   ),
                  // ),
                  // GetX<ProductController>(
                  //   builder: (controller) {
                  //     return AspectRatio(
                  //       aspectRatio: 1.35,
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         shrinkWrap: true,
                  //         itemCount: productController.productList.length,
                  //         itemBuilder: (context, index) =>
                  //             HorizontalProductTile(
                  //           name: controller.productList[index].productName,
                  //           image: controller.productList[index].image,
                  //           description:
                  //               controller.productList[index].description,
                  //           discount: controller.productList[index].discount,
                  //           price: controller.productList[index].price,
                  //           ontap: () => Get.to(() => OrderPage(
                  //                 price: controller.productList[index].price,
                  //                 brand:
                  //                     controller.productList[index].brandStore,
                  //                 description:
                  //                     controller.productList[index].description,
                  //                 discount:
                  //                     controller.productList[index].discount,
                  //                 image: controller.productList[index].image,
                  //                 name:
                  //                     controller.productList[index].productName,
                  //               )),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),

                  //test2
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Add to Fav"),
                        Text("View More"),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where("offer", isEqualTo: "No")
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
                          aspectRatio: 1.35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: firestoreProducts.length,
                            itemBuilder: (context, index) => TestTile(
                              name: firestoreProducts[index]["productName"],
                              description: firestoreProducts[index]
                                  ["description"],
                              discount: firestoreProducts[index]["discount"]
                                  .toString(),
                              price:
                                  firestoreProducts[index]["price"].toString(),
                              image: firestoreProducts[index]["image"],
                              brand: firestoreProducts[index]["brand_store"],
                              category: firestoreProducts[index]["category"],
                              offer: firestoreProducts[index]["offer"],
                              productID: firestoreProducts[index]["productID"],
                              type: firestoreProducts[index]["type"],
                              addToWishlist: () {},
                              ontap: () => Get.to(
                                () => OrderPage(
                                  image: firestoreProducts[index]['image'],
                                  price: firestoreProducts[index]['price'],
                                  name: firestoreProducts[index]['productName'],
                                  brand: firestoreProducts[index]['brand_store']
                                      .toUpperCase(),
                                  description: firestoreProducts[index]
                                      ["description"],
                                  discount: firestoreProducts[index]['discount']
                                      .toString(),
                                  category: firestoreProducts[index]
                                      ['category'],
                                  offer: firestoreProducts[index]['offer'],
                                  productID: firestoreProducts[index]
                                      ['productID'],
                                  type: firestoreProducts[index]['type'],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  //Categories
                  Obx(
                    () => StickyHeader(
                      header: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryName.length,
                          itemBuilder: (context, index) => CategoryButton(
                            categoryName:
                                categoryName[index]["name"].toString(),
                            ontap: () {
                              _categoryName.value =
                                  categoryName[index]["name"].toString();
                            },
                            color: categoryName[index]["name"] ==
                                    _categoryName.value
                                ? "0xff000000"
                                : "0xffededed",
                            textColor: categoryName[index]["name"] ==
                                    _categoryName.value
                                ? "0xffffffff"
                                : "0xff000000",
                          ),
                        ),
                      ),
                      content: //All Products acc to category selection
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              _categoryName.value.toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _categoryName.value == "All"
                                  ? FirebaseFirestore.instance
                                      .collection('products')
                                      .snapshots()
                                  : _categoryName.value == "Men" ||
                                          _categoryName.value == "Women" ||
                                          _categoryName.value == "Kids"
                                      ? FirebaseFirestore.instance
                                          .collection('products')
                                          .where("category",
                                              isEqualTo: _categoryName.value)
                                          .snapshots()
                                      : FirebaseFirestore.instance
                                          .collection('products')
                                          .where("type",
                                              isEqualTo: _categoryName.value)
                                          .snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        kToolbarHeight,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        kToolbarHeight,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  List<QueryDocumentSnapshot<Object?>>
                                      firestoreProducts = snapshot.data!.docs;
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Wrap(
                                      children: List.generate(
                                        firestoreProducts.length,
                                        (index) => ProductTile(
                                            name: firestoreProducts[index]
                                                ["productName"],
                                            description:
                                                firestoreProducts[index]
                                                    ["description"],
                                            discount: firestoreProducts[index]
                                                    ["discount"]
                                                .toString(),
                                            price: firestoreProducts[index]
                                                    ["price"]
                                                .toString(),
                                            image: firestoreProducts[index]
                                                ["image"],
                                            ontap: () => Get.to(
                                                  () => OrderPage(
                                                    image:
                                                        firestoreProducts[index]
                                                            ['image'],
                                                    price:
                                                        firestoreProducts[index]
                                                            ['price'],
                                                    name:
                                                        firestoreProducts[index]
                                                            ['productName'],
                                                    brand:
                                                        firestoreProducts[index]
                                                                ['brand_store']
                                                            .toUpperCase(),
                                                    description:
                                                        firestoreProducts[index]
                                                            ["description"],
                                                    discount:
                                                        firestoreProducts[index]
                                                                ['discount']
                                                            .toString(),
                                                    category:
                                                        firestoreProducts[index]
                                                            ['category'],
                                                    offer:
                                                        firestoreProducts[index]
                                                            ['offer'],
                                                    productID:
                                                        firestoreProducts[index]
                                                            ['productID'],
                                                    type:
                                                        firestoreProducts[index]
                                                            ['type'],
                                                  ),
                                                )),
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
                              backgroundColor: Colors.black,
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
                                      backgroundColor: Colors.black,
                                      heroTag: "btn2",
                                      onPressed: () =>
                                          Get.to(SuperAdminUserViewPage()),
                                      child: const Icon(Icons.person),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FloatingActionButton(
                                      backgroundColor: Colors.black,
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
