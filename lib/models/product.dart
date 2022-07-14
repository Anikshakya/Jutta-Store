// // To parse this JSON data, do
// //
// //     final product = productFromJson(jsonString);

// import 'dart:convert';

// List<Product> productFromJson(String str) =>
//     List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

// String productToJson(List<Product> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Product {
//   Product({
//     required this.brandStore,
//     required this.category,
//     required this.description,
//     required this.discount,
//     required this.image,
//     required this.offer,
//     required this.price,
//     required this.productId,
//     required this.productName,
//     required this.type,
//   });

//   String brandStore;
//   String category;
//   String description;
//   String discount;
//   String image;
//   String offer;
//   String price;
//   String productId;
//   String productName;
//   String type;

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         brandStore: json["brand_store"],
//         category: json["category"],
//         description: json["description"],
//         discount: json["discount"],
//         image: json["image"],
//         offer: json["offer"],
//         price: json["price"],
//         productId: json["productID"],
//         productName: json["productName"],
//         type: json["type"],
//       );

//   Map<String, dynamic> toJson() => {
//         "brand_store": brandStore,
//         "category": category,
//         "description": description,
//         "discount": discount,
//         "image": image,
//         "offer": offer,
//         "price": price,
//         "productID": productId,
//         "productName": productName,
//         "type": type,
//       };
// }
