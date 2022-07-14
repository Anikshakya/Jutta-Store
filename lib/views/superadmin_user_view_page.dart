import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/views/user_edit_page.dart';
import 'package:jutta_ghar/tiles/superadmin_user_tile.dart';

class SuperAdminUserViewPage extends StatefulWidget {
  const SuperAdminUserViewPage({Key? key}) : super(key: key);

  @override
  State<SuperAdminUserViewPage> createState() => _SuperAdminUserViewPageState();
}

class _SuperAdminUserViewPageState extends State<SuperAdminUserViewPage> {
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
              textCapitalization: TextCapitalization.none,
              onChanged: ((value) {
                setState(() {
                  searchKey = value;
                });
              }),
              controller: clearSearchController,
              autofocus: true,
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
                  hintText: 'Search by email....',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchKey != "")
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .where("email", isGreaterThanOrEqualTo: searchKey)
                            .where("email", isLessThan: searchKey + 'z')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<QueryDocumentSnapshot<Object?>> firestoreUser =
                            snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: firestoreUser.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return UserTile(
                              adminRole: firestoreUser[index]['admin_role'],
                              email: firestoreUser[index]['email'],
                              name: firestoreUser[index]['name'],
                              phoneNumber: firestoreUser[index]['contact'],
                              role: firestoreUser[index]['role'],
                              ontap: () {
                                Get.to(UserEditPage(
                                  name: firestoreUser[index]['name'],
                                  email: firestoreUser[index]['email'],
                                  contact: firestoreUser[index]['contact'],
                                  adminRole: firestoreUser[index]['admin_role'],
                                  role: firestoreUser[index]['role'],
                                ));
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      List<QueryDocumentSnapshot<Object?>> firestoreUser =
                          snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: firestoreUser.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return UserTile(
                            adminRole: firestoreUser[index]['admin_role'],
                            email: firestoreUser[index]['email'],
                            name: firestoreUser[index]['name'],
                            phoneNumber: firestoreUser[index]['contact'],
                            role: firestoreUser[index]['role'],
                            ontap: () {
                              Get.to(
                                UserEditPage(
                                  name: firestoreUser[index]['name'],
                                  email: firestoreUser[index]['email'],
                                  contact: firestoreUser[index]['contact'],
                                  adminRole: firestoreUser[index]['admin_role'],
                                  role: firestoreUser[index]['role'],
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
