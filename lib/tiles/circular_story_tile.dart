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
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const Text("Name"),
                // CachedNetworkImage(
                //   imageUrl: widget.image,
                //   height: MediaQuery.of(context).size.width * 0.46,
                //   width: MediaQuery.of(context).size.width * 0.46,
                //   fit: BoxFit.cover,
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Text(widget.name),
              ],
            ),
    );
  }
}
