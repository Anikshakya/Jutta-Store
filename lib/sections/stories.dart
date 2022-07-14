// import 'package:flutter/material.dart';
// import 'package:jutta_ghar/models/url_parse.dart';
// import 'package:jutta_ghar/tiles/circular_story_tile.dart';

// class Stories {
   // //from json
  // List<RandomImage>? _randomImage;
//    @override
//   void initState() {
//     JsonParseService.getData().then((value) {
//       setState(() {
//         _randomImage = value;
//         _loading = false;
//       });
//     });
//     super.initState();
//   }
//   bool? _loading;

//   allStories() {
//     return
//      _loading == false
//                       ? AspectRatio(
//                           aspectRatio: 4.2,
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             scrollDirection: Axis.horizontal,
//                             itemCount: 15,
//                             itemBuilder: ((context, index) => CircularStoryTile(
//                                   index: index,
//                                   image: _randomImage![index].thumbnailUrl,
//                                   name: _randomImage![index].id.toString(),
//                                   onTapAddStory: () {
//                                     pickImage(ImageSource.camera);
//                                   },
//                                   onTapStory: () => Get.to(
//                                     () => Story(
//                                       image: _randomImage![index].thumbnailUrl,
//                                       name:
//                                           _randomImage![index].title.toString(),
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                         )
//                       : const Padding(
//                           padding: EdgeInsets.all(15),
//                           child: Center(child: CircularProgressIndicator()),
//                         ),
//   }
// }
