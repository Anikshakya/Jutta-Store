import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddStory extends StatefulWidget {
  const AddStory({Key? key}) : super(key: key);

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.file(
            box.read("a"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      //  Container(
      //   color: Colors.blue,
      //   child: const Center(child: Text("Add your story")),
      // ),
    );
  }
}
