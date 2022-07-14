//Dont forget to add camera: ^0.9.8+1 to pubspec.yaml file & min sdk must be above 21
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class LiveCameraPreview extends StatefulWidget {
  const LiveCameraPreview({Key? key}) : super(key: key);

  @override
  State<LiveCameraPreview> createState() => _LiveCameraPreviewState();
}

class _LiveCameraPreviewState extends State<LiveCameraPreview> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for caputred image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose(); //to dispose the camera
    super.dispose();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      //cameras[0] = first camera, change to 1 to another camera
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //use this to control the flash of camera
      controller!.setFlashMode(FlashMode.off);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("No Camera found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: image == null
            ? Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: controller == null
                        ? const Center(
                            child: Text("Loading Camera..."),
                          )
                        : !controller!.value.isInitialized
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CameraPreview(controller!),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 40,
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            try {
                              if (controller != null) {
                                //check if contrller is not null
                                if (controller!.value.isInitialized) {
                                  //check if controller is initialized
                                  image = await controller!
                                      .takePicture(); //capture image
                                  setState(
                                    () {
                                      //update UI
                                    },
                                  );
                                }
                              }
                            } catch (e) {
                              print(e); //show error
                            }
                          },
                          child: const Icon(
                            Icons.circle_rounded,
                            color: Colors.black,
                            size: 50,
                          )),
                    ),
                  ),
                ],
              )
            //show the captured image
            : Image.file(
                File(image!.path),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
