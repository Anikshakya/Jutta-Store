// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:jutta_ghar/tiles/cart_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/views/order_page.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //Current User
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "SHOPPING CART",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: deleteAllCartItems,
              icon: Icon(
                Icons.delete_outline_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.email)
            .collection("products")
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text(
              "Your cart is empty. \nLet's do some shopping",
              textAlign: TextAlign.center,
            ));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<QueryDocumentSnapshot<Object?>> firestoreProducts =
                snapshot.data!.docs;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: List.generate(
                  firestoreProducts.length,
                  (index) => CartTile(
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
                    ontap: () => Get.to(
                      () => OrderPage(
                        image: firestoreProducts[index]['image'],
                        price: firestoreProducts[index]['price'],
                        name: firestoreProducts[index]['productName'],
                        brand: firestoreProducts[index]['brand_store']
                            .toUpperCase(),
                        description: firestoreProducts[index]["description"],
                        discount:
                            firestoreProducts[index]['discount'].toString(),
                        category: firestoreProducts[index]['category'],
                        offer: firestoreProducts[index]['offer'],
                        productID: firestoreProducts[index]['productID'],
                        type: firestoreProducts[index]['type'],
                      ),
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

  //Delete from Cart
  Future deleteAllCartItems() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    FirebaseFirestore.instance
        .collection("cart")
        .doc(user!.email)
        .delete()
        .then((value) => Navigator.pop(context))
        .then((value) => Get.snackbar(
              "All Item Removed",
              "All Items deleted from cart",
              duration: const Duration(seconds: 1),
            ));
  }
}
