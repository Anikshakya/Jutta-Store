import 'package:flutter/material.dart';

class AdminViewProductTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final image, description, price, discount, name;
  final VoidCallback? ontap;
  const AdminViewProductTile(
      {Key? key,
      this.image,
      this.description,
      this.price,
      this.discount,
      this.name,
      this.ontap})
      : super(key: key);

  @override
  State<AdminViewProductTile> createState() => _AdminViewProductTileState();
}

class _AdminViewProductTileState extends State<AdminViewProductTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              widget.image,
              height: MediaQuery.of(context).size.height / 4.5,
              width: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.name),
            Text(widget.description),
            Text(widget.price),
            Text(widget.discount),
          ],
        ),
      ),
    );
  }
}
