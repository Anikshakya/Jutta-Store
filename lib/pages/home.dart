// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/pages/admin_view_page.dart';
import 'package:jutta_ghar/pages/superadmin_user_view_page.dart';
import 'package:jutta_ghar/pages/vendor_admin_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Center(
                      child: Text(
                        "Log out",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25),
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
                                  Get.to(() => VendorAdminViewPage(
                                        adminRole: firestoreItems[0]
                                                ["admin_role"]
                                            .toString(),
                                      ));
                                },
                                child: const Icon(Icons.add),
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
      ),
    );
  }
}
