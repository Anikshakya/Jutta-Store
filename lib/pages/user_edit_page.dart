// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:get/get.dart';

class UserEditPage extends StatefulWidget {
  final name, email, role, adminRole, contact;
  const UserEditPage(
      {Key? key,
      this.name,
      this.email,
      this.role,
      this.adminRole,
      this.contact})
      : super(key: key);

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  @override
  void initState() {
    nameController.text = widget.name;
    emailController.text = widget.email;
    contactController.text = widget.contact;
    roleController.text = widget.role;
    adminRoleController.text = widget.adminRole;
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;

  //text controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final roleController = TextEditingController();
  final adminRoleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    adminRoleController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () => deleteUser(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Icon(
                Icons.delete,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Super Admin user user page"),
              Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    controller: nameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "email",
                    ),
                    controller: emailController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Contact",
                    ),
                    controller: contactController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Role",
                    ),
                    controller: roleController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Admin Role",
                    ),
                    controller: adminRoleController,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    update(context);
                  },
                  child: const Text("Update")),
            ],
          ),
        ),
      ),
    );
  }

  Future update(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //update file without image upload
    try {
      DocumentReference documentReferencer =
          FirebaseFirestore.instance.collection("users").doc(widget.email);
      Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'contact': contactController.text.trim(),
        'role': roleController.text.trim(),
        'admin_role': adminRoleController.text.trim(),
      };
      await documentReferencer
          .update(data)
          .then((value) => Navigator.pop(context))
          .then((value) => Navigator.pop(context))
          .then((value) => Get.snackbar("Success", "Data Updated Successfully",
              backgroundColor: const Color.fromARGB(160, 105, 240, 175)));
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message.toString(), false);
    }
  }

  //delete firebaseFirestore item
  Future deleteUser(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.email)
        .delete()
        // .then((value) => FirebaseAuth.instance.)
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .then((value) => Get.snackbar("Success", "User Deleted Successfully",
            backgroundColor: const Color.fromARGB(160, 105, 240, 175)));
  }
}
