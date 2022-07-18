// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class ProductTile extends StatefulWidget {
  final image, description, price, discount, name;
  final VoidCallback? ontap;

  const ProductTile({
    Key? key,
    this.image,
    this.description,
    this.price,
    this.discount,
    this.name,
    this.ontap,
  }) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.46,
        margin: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: 4,
          right: 4,
        ),
        padding: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(232, 204, 204, 204),
              offset: Offset(2, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        fav = !fav;
                      });
                      fav == true
                          ? Get.snackbar("Added Sucessfully",
                              "The item was added succesfully",
                              duration: const Duration(seconds: 1))
                          : Get.snackbar("Removed Sucessfully",
                              "The item was removed succesfully",
                              duration: const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        fav == false
                            ? Icons.favorite_border
                            : Icons.favorite_outlined,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                widget.discount.isEmpty
                    ? const SizedBox()
                    : Container(
                        height: 20,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                "- " + widget.discount.toString() + "%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.discount.isEmpty
                      ? Text(
                          "Rs. " + widget.price,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      : Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Rs.",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                    text:
                                        "${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Rs. " + widget.price,
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
