// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/tiles/wishlist_tile.dart';
import 'package:jutta_ghar/views/order_page.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  //To indicate user
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          "YOUR WISHLIST",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_rounded))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .doc(user!.email)
            .collection("products")
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                itemBuilder: (context, index) => WishlistTile(
                  name: firestoreProducts[index]["productName"],
                  description: firestoreProducts[index]["description"],
                  discount: firestoreProducts[index]["discount"].toString(),
                  price: firestoreProducts[index]["price"].toString(),
                  image: firestoreProducts[index]["image"],
                  ontap: () => Get.to(
                    () => OrderPage(
                      image: firestoreProducts[index]['image'],
                      price: firestoreProducts[index]['price'],
                      name: firestoreProducts[index]['productName'],
                      brand:
                          firestoreProducts[index]['brand_store'].toUpperCase(),
                      description: firestoreProducts[index]["description"],
                      discount: firestoreProducts[index]['discount'].toString(),
                      category: firestoreProducts[index]['category'],
                      offer: firestoreProducts[index]['offer'],
                      productID: firestoreProducts[index]['productID'],
                      type: firestoreProducts[index]['type'],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}



// Container(
//         alignment: Alignment.center,
//         child: Text("No Items"),
//       ),