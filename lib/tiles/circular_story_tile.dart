// ignore_for_file: prefer_typing_uninitialized_variables
import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';

class CircularStoryTile extends StatefulWidget {
  final image, name, index;
  final VoidCallback? onTapAddStory, onTapStory;
  const CircularStoryTile(
      {Key? key,
      this.image,
      this.name,
      this.index,
      this.onTapAddStory,
      this.onTapStory})
      : super(key: key);

  @override
  State<CircularStoryTile> createState() => _CircularStoryTileState();
}

class _CircularStoryTileState extends State<CircularStoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
      child: widget.index == 0
          ? Column(
              children: [
                GestureDetector(
                  onTap: widget.onTapAddStory,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Text("+"),
              ],
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: widget.onTapStory,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(widget.name.toString()),
              ],
            ),
    );
  }
}
