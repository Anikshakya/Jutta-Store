import 'package:flutter/material.dart';
import 'package:jutta_ghar/views/cart.dart';
import 'package:jutta_ghar/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jutta_ghar/views/settings_page.dart';

class BottomNav extends StatefulWidget {
  final int index;
  const BottomNav({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  List<Widget>? pages;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _selectedIndex = widget.index;
    pages = [
      const HomePage(),
      const CartPage(),
      const SettingsPage(),
    ];
    super.initState();
  }

  _handleTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages![_selectedIndex],
      //----Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        onTap: _handleTap,
        currentIndex: _selectedIndex,
        elevation: 30,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.black,
        selectedFontSize: 13,
        iconSize: 22,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Center(child: Icon(Icons.shopping_bag_outlined)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("cart")
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
                            return Container(
                              height: 17,
                              width: 17,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 217, 193),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  firestoreWishlistData.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 11),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Shop'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
