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
      offer,
      type,
      productID;

  const AdminEditPage({
    Key? key,
    this.brand_store_name,
    this.image,
    this.description,
    this.price,
    this.discount,
    this.name,
    this.category,
    this.productID,
    this.offer,
    this.type,
  }) : super(key: key);

  @override
  State<AdminEditPage> createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  var dropDownOffer = 'Offer';
  var dropDownCategory = 'Category';
  var dropDownType = 'Type';
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    dropDownCategory = widget.category;
    dropDownOffer = widget.offer;
    dropDownType = widget.type;
    brandStoreController.text = widget.brand_store_name;
    nameController.text = widget.name;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
    discountController.text = widget.discount;

    super.initState();
  }

  //text controller
  final brandStoreController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
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
                    return firestoreItems[0]["admin_role"] == "superAdmin"
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Category: "),
                                      DropdownButton<String>(
                                        value: dropDownCategory,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownCategory = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Category',
                                          'Men',
                                          'Women',
                                          'Kids',
                                          'Unisex',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Type: "),
                                      DropdownButton<String>(
                                        value: dropDownType,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownType = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Type',
                                          'Sports',
                                          'Classic',
                                          'Casual'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Offer: "),
                                      DropdownButton<String>(
                                        value: dropDownOffer,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownOffer = newValue!;
                                          });
                                        },
                                        items: <String>['Offer', 'Yes', 'No']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Category: "),
                                      DropdownButton<String>(
                                        value: dropDownCategory,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownCategory = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Category',
                                          'Men',
                                          'Women',
                                          'Kids',
                                          'Unisex',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Type: "),
                                      DropdownButton<String>(
                                        value: dropDownType,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownType = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Type',
                                          'Sports',
                                          'Classic',
                                          'Casual'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Offer: "),
                                      DropdownButton<String>(
                                        value: dropDownOffer,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownOffer = newValue!;
                                          });
                                        },
                                        items: <String>['Offer', 'Yes', 'No']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              dropDownOffer == "Yes"
                  ? Container(
                      height: 50,
                      width: 50,
                      color: Colors.green,
                    )
                  : const SizedBox(),
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
          'productName': nameController.text.trim(),
          'brand_store': brandStoreController.text.trim(),
          'category': dropDownCategory.trim(),
          'description': descriptionController.text.trim(),
          'discount': discountController.text.trim(),
          'price': priceController.text.trim(),
          'offer': dropDownOffer.trim(),
          'type': dropDownType.trim(),
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
                'category': dropDownCategory.trim(),
                'description': descriptionController.text.trim(),
                'discount': discountController.text.trim(),
                'price': priceController.text.trim(),
                'offer': dropDownOffer.trim(),
                'type': dropDownType.trim(),
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
