// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final categoryName, color, textColor;
  final VoidCallback? ontap;
  const CategoryButton(
      {Key? key, this.categoryName, this.ontap, this.color, this.textColor})
      : super(key: key);

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        margin: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 4,
        ),
        decoration: BoxDecoration(
          color: Color(int.parse(widget.color)),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(232, 235, 235, 235),
              offset: Offset(2, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 6, bottom: 6, left: 28, right: 28),
          child: Center(
              child: Text(
            widget.categoryName,
            style: TextStyle(
                color: Color(int.parse(widget.textColor)), fontSize: 12),
          )),
        ),
      ),
    );
  }
}
