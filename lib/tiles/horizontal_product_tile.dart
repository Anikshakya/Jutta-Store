// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HorizontalProductTile extends StatefulWidget {
  final image, description, price, discount, name;
  final VoidCallback? ontap;
  const HorizontalProductTile(
      {Key? key,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.ontap})
      : super(key: key);

  @override
  State<HorizontalProductTile> createState() => _HorizontalProductTileState();
}

class _HorizontalProductTileState extends State<HorizontalProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.48,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              height: MediaQuery.of(context).size.width * 0.46,
              width: MediaQuery.of(context).size.width * 0.46,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              textAlign: TextAlign.center,
            ),
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
