import 'package:flutter/material.dart';

class ColorTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final color, text, selectionColor;
  final VoidCallback onTap;
  const ColorTile({
    Key? key,
    required this.onTap,
    required this.color,
    required this.text,
    this.selectionColor,
  }) : super(key: key);

  @override
  State<ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 12,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: Color(int.parse(widget.selectionColor)),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(232, 235, 235, 235),
                offset: Offset(2, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                color: Color(int.parse(widget.color)),
              ),
              Text(
                widget.text,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
