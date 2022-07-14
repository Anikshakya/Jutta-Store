// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class BrandTile extends StatefulWidget {
  final image, brandName;
  final VoidCallback? ontap;

  const BrandTile({
    Key? key,
    this.image,
    this.ontap,
    this.brandName,
  }) : super(key: key);

  @override
  State<BrandTile> createState() => _BrandTileState();
}

class _BrandTileState extends State<BrandTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.64,
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 219, 219, 219),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: widget.image,
            height: 100,
            width: 200,
          ),
        ),
      ),
    );
  }
}
