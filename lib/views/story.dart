// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Story extends StatefulWidget {
  final image, name;
  const Story({Key? key, this.image, this.name}) : super(key: key);

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  void initState() {
    super.initState();
    popTimer();
  }

  popTimer() async {
    await Future.delayed(const Duration(seconds: 5), () {})
        .then((value) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Image.network(
            widget.image,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Text(
            widget.name,
            style: const TextStyle(color: Colors.black, fontSize: 22),
          ),
        ],
      ),
    ));
  }
}
