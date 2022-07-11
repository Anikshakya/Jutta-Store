// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jutta_ghar/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

class AdminUploadPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final brandUploadName;

  const AdminUploadPage({
    Key? key,
    this.brandUploadName,
  }) : super(key: key);

  @override
  State<AdminUploadPage> createState() => _AdminUploadPageState();
}

class _AdminUploadPageState extends State<AdminUploadPage> {
  var dropDownValue = "Offer";
  @override
  void initState() {
    brandStoreController.text = widget.brandUploadName;
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

  clearController() {
    brandStoreController.clear();
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    discountController.clear();
    categoryController.clear();
  }

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
            onTap: clearController,
            child: Align(
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "Clear All",
                  style: TextStyle(color: Colors.black),
                ),
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
              const Text("admin add page"),
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
                    return firestoreItems[0]["admin_role"] == "superAdmin"
                        ? Column(
                            children: [
                              TextField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Product Name",
                                ),
                                controller: nameController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Brand/Store Name",
                                ),
                                controller: brandStoreController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                ),
                                controller: descriptionController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                ),
                                controller: categoryController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Price",
                                ),
                                controller: priceController,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Discount",
                                ),
                                controller: discountController,
                              ),
                              DropdownButton<String>(
                                value: dropDownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Offer',
                                  'Yes',
                                  'No'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
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
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Description",
                                ),
                                controller: descriptionController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                ),
                                controller: categoryController,
                              ),
                              TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Price",
                                ),
                                controller: priceController,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Discount",
                                ),
                                controller: discountController,
                              ),
                              DropdownButton<String>(
                                value: dropDownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Offer',
                                  'Yes',
                                  'No'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
                    upload(context);
                  },
                  child: const Text("Upload")),
            ],
          ),
        ),
      ),
    );
  }

  Future upload(context) async {
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
        var docId = FirebaseFirestore.instance.collection("products").doc().id;
        DocumentReference documentReferencer = FirebaseFirestore.instance
            .collection("products")
            .doc(docId.toString());
        Map<String, dynamic> data = {
          'productName': nameController.text.trim(),
          'brand_store': brandStoreController.text.trim(),
          'category': categoryController.text.trim(),
          'description': descriptionController.text.trim(),
          'discount': discountController.text.trim(),
          'price': priceController.text.trim(),
          'productID': docId.trim(),
          'offer': dropDownValue.trim(),
        };
        await documentReferencer
            .set(data)
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
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask uploadTask = ref.putFile(_imageFile!);
        uploadTask.whenComplete(() async {
          //download and update the file
          String url = await ref.getDownloadURL();
          if (url != '') {
            var docId =
                FirebaseFirestore.instance.collection("products").doc().id;
            DocumentReference documentReferencer =
                FirebaseFirestore.instance.collection("products").doc(docId);
            Map<String, dynamic> data = {
              'image': url,
              'productName': nameController.text.trim(),
              'brand_store': brandStoreController.text.trim(),
              'category': categoryController.text.trim(),
              'description': descriptionController.text.trim(),
              'discount': discountController.text.trim(),
              'price': priceController.text.trim(),
              'productID': docId.trim(),
              'offer': dropDownValue.trim(),
            };
            await documentReferencer
                .set(data)
                .then((value) => Navigator.pop(context))
                .then((value) => Navigator.pop(context))
                .then((value) => Get.snackbar(
                    "Success", "Data Uploaded Succesfully",
                    backgroundColor: const Color.fromARGB(160, 105, 240, 175)))
                .then((value) => setState(() {
                      box.write("a", null);
                    }));
          }
        });
      } on FirebaseException catch (e) {
        Utils.showSnackBar(e.message.toString(), false);
      }
    }
  }
}
