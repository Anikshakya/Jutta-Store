// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:path/path.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AdminEditPage extends StatefulWidget {
  final image,
      description,
      price,
      discount,
      name,
      category,
      brand_store_name,
      productID;
  const AdminEditPage(
      {Key? key,
      this.brand_store_name,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.category,
      this.productID})
      : super(key: key);

  @override
  State<AdminEditPage> createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  @override
  void initState() {
    brandStoreController.text = widget.brand_store_name;
    nameController.text = widget.name;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
    discountController.text = widget.discount;
    categoryController.text = widget.category;
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;

  //text controller
  final brandStoreController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
    categoryController.dispose();
    brandStoreController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () => deleteProduct(context),
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
              const Text("admin edit page"),
              StreamBuilder<QuerySnapshot>(
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
                    return firestoreItems[0]["admin_role"] == "SuperAdmin"
                        ? Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Product Name",
                                ),
                                controller: nameController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Brand/Store Name",
                                ),
                                controller: brandStoreController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                ),
                                controller: descriptionController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                ),
                                controller: categoryController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Price",
                                ),
                                controller: priceController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Discount",
                                ),
                                controller: discountController,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Product Name",
                                ),
                                controller: nameController,
                              ),
                              TextField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: "Brand/Store Name",
                                ),
                                controller: brandStoreController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                ),
                                controller: descriptionController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                ),
                                controller: categoryController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Price",
                                ),
                                controller: priceController,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: "Discount",
                                ),
                                controller: discountController,
                              ),
                            ],
                          );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      child: const Text("Camera")),
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: const Text("Gallery"))
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
    if (_imageFile == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      //update file without image upload
      try {
        DocumentReference documentReferencer = FirebaseFirestore.instance
            .collection("products")
            .doc(widget.productID);
        Map<String, dynamic> data = {
          'brand_store': brandStoreController.text.trim(),
          'category': categoryController.text.trim(),
          'description': descriptionController.text.trim(),
          'discount': discountController.text.trim(),
          'price': priceController.text.trim(),
        };
        await documentReferencer
            .update(data)
            .then((value) => Navigator.pop(context))
            .then((value) => Navigator.pop(context))
            .then((value) => Get.snackbar(
                "Success", "Data Updated Successfully",
                backgroundColor: const Color.fromARGB(160, 105, 240, 175)));
      } on FirebaseException catch (e) {
        Utils.showSnackBar(e.message.toString(), false);
      }
    } else {
      final fileName = basename(_imageFile!.path);
      String destination = "images/$fileName";
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      //-----Upload image File and update-----
      try {
        String url;
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(_imageFile!);
        uploadTask.whenComplete(
          () async {
            //download and update the file
            url = await ref.getDownloadURL();
            if (url != '') {
              DocumentReference documentReferencer = FirebaseFirestore.instance
                  .collection("products")
                  .doc(widget.productID);
              Map<String, dynamic> data = {
                'image': url,
                'productName': nameController.text.trim(),
                'brand_store': brandStoreController.text.trim(),
                'category': categoryController.text.trim(),
                'description': descriptionController.text.trim(),
                'discount': discountController.text.trim(),
                'price': priceController.text.trim(),
              };
              await documentReferencer
                  .update(data)
                  .then((value) => Navigator.pop(context))
                  .then((value) => Navigator.pop(context))
                  .then((value) => Get.snackbar(
                      "Success", "Data Updated Successfully",
                      backgroundColor:
                          const Color.fromARGB(160, 105, 240, 175)))
                  .then(
                    (value) => setState(
                      () {
                        box.write("a", null);
                      },
                    ),
                  );
            }
          },
        );
      } on FirebaseException catch (e) {
        Utils.showSnackBar(e.message.toString(), false);
      }
    }
  }

  //delete firebaseFirestore item
  Future deleteProduct(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productID)
        .delete()
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .then((value) => Get.snackbar("Success", "Data Deleted Successfully",
            backgroundColor: const Color.fromARGB(160, 105, 240, 175)));
  }
}
