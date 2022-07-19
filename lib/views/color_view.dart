import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/color/color_list.dart';
import 'package:jutta_ghar/color/color_tile.dart';
import 'package:jutta_ghar/tiles/products_tiles.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ColorView extends StatefulWidget {
  const ColorView({Key? key}) : super(key: key);

  @override
  State<ColorView> createState() => _ColorViewState();
}

class _ColorViewState extends State<ColorView> {
  final shoescolor = "Black".obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 25),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 28),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: const [
            SizedBox(
              width: 8,
            ),
            Text(
              "SELECT YOUR COLOR",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("banner_image")
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    List<QueryDocumentSnapshot<Object?>> firestoreBannerImage =
                        snapshot.data!.docs;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: CarouselSlider.builder(
                          unlimitedMode: true,
                          itemCount: firestoreBannerImage.length,
                          enableAutoSlider: true,
                          autoSliderDelay: const Duration(seconds: 3),
                          autoSliderTransitionTime:
                              const Duration(milliseconds: 500),
                          slideIndicator: CircularSlideIndicator(
                              itemSpacing: 15.0,
                              indicatorBackgroundColor:
                                  const Color.fromARGB(95, 197, 197, 197),
                              currentIndicatorColor: Colors.white,
                              padding: const EdgeInsets.only(bottom: 10)),
                          slideBuilder: (index) {
                            return CachedNetworkImage(
                              imageUrl: firestoreBannerImage[index]["image"],
                              fit: BoxFit.cover,
                            );
                          }),
                    );
                  }
                })),
            const Padding(
              padding: EdgeInsets.only(top: 25, bottom: 5, left: 15),
              child: Text(
                "COLOUR CHOICES",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Obx(
              () => StickyHeader(
                header: Container(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  padding: const EdgeInsets.only(left: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 76,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: colorList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ColorTile(
                          onTap: () {
                            shoescolor.value =
                                colorList[index]["text"].toString();
                          },
                          color: colorList[index]['color'],
                          text: colorList[index]['text'],
                          selectionColor:
                              shoescolor.value == colorList[index]['text']
                                  ? "0xfff0f0f0"
                                  : "0xffffffff",
                        );
                      }),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        shoescolor.value.toUpperCase(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: shoescolor.value == "Red" ||
                                shoescolor.value == "Black" ||
                                shoescolor.value == "Blue" ||
                                shoescolor.value == "White" ||
                                shoescolor.value == "Yellow"
                            ? FirebaseFirestore.instance
                                .collection('products')
                                .where("color", isEqualTo: shoescolor.value)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('products')
                                .where("color", isEqualTo: shoescolor.value)
                                .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            List<QueryDocumentSnapshot<Object?>>
                                firestoreitems = snapshot.data!.docs;
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: List.generate(
                                      firestoreitems.length,
                                      ((index) => ProductTile(
                                            image: firestoreitems[index]
                                                ['image'],
                                            name: firestoreitems[index]
                                                ['productName'],
                                            description: firestoreitems[index]
                                                ['description'],
                                            price: firestoreitems[index]
                                                    ['price']
                                                .toString(),
                                            discount: firestoreitems[index]
                                                    ['discount']
                                                .toString(),
                                            ontap: () {
                                              Get.to(() => OrderPage(
                                                    image: firestoreitems[index]
                                                        ['image'],
                                                    price: firestoreitems[index]
                                                            ['price']
                                                        .toString(),
                                                    name: firestoreitems[index]
                                                        ['productName'],
                                                    discount:
                                                        firestoreitems[index]
                                                                ['discount']
                                                            .toString(),
                                                    description:
                                                        firestoreitems[index]
                                                            ['description'],
                                                    brand: firestoreitems[index]
                                                        ['brand_store'],
                                                    category:
                                                        firestoreitems[index]
                                                            ['category'],
                                                    offer: firestoreitems[index]
                                                        ['offer'],
                                                    productID:
                                                        firestoreitems[index]
                                                            ['productID'],
                                                    type: firestoreitems[index]
                                                        ['type'],
                                                  ));
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
