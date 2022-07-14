import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminViewProductTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final image, description, price, discount, offer, name;
  final VoidCallback? ontap;
  const AdminViewProductTile(
      {Key? key,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.ontap,
      this.offer})
      : super(key: key);

  @override
  State<AdminViewProductTile> createState() => _AdminViewProductTileState();
}

class _AdminViewProductTileState extends State<AdminViewProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.49,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              width: MediaQuery.of(context).size.width * 0.47,
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
            Text("Rs. " + widget.price),
            Text("Discount: " + widget.discount + "%"),
            Text("Offer: " + widget.offer),
          ],
        ),
      ),
    );
  }
}
