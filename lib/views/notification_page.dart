import 'package:flutter/material.dart';
import 'package:jutta_ghar/widgets/custom_refresher_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "NOTIFICATIONS",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        elevation: 2.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CustomRefreshWidget(
        widget: const Padding(
          padding: EdgeInsets.only(top: 40),
          child: SpinKitThreeBounce(
            color: Colors.black,
            size: 24.0,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color.fromARGB(255, 244, 246, 252),
              height: MediaQuery.of(context).size.height / 1.12,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/JuttaGhar.png",
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    "Notification will appear here",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    "We will notify you when something new and\ninteresting is happening",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 15,
                        color: Color.fromARGB(255, 127, 129, 128)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
