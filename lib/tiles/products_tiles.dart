// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductTile extends StatefulWidget {
  final image, description, price, discount, name;
  final VoidCallback? ontap;
  const ProductTile(
      {Key? key,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.ontap})
      : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.48,
        padding: const EdgeInsets.only(top: 10, left: 10.5),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              width: MediaQuery.of(context).size.width * 0.46,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.name, textAlign: TextAlign.center),
            Text(
              widget.description,
              textAlign: TextAlign.center,
            ),
            widget.discount.isEmpty == true
                ? Text("Rs. " + widget.price)
                : Column(
                    children: [
                      Text(
                          "Rs. ${(double.parse(widget.price) - (double.parse(widget.price) * (double.parse(widget.discount) / 100)))}"),
                      RichText(
                        text: TextSpan(
                          text: "Rs. " + widget.price,
                          style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,
                          ),
                          children: [
                            TextSpan(
                              text: "  -" + widget.discount + "%",
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
