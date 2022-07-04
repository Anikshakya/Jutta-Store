// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jutta_ghar/pages/forgot_password.dart';
import 'package:jutta_ghar/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jutta_ghar/pages/sign_up.dart';
import 'package:jutta_ghar/utils/shapes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:jutta_ghar/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Validator key
  final formKey = GlobalKey<FormState>();
  final successKey = GlobalKey<ScaffoldMessengerState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  //Text contorllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (conext) {
            return AlertDialog(
              title: const Text("Do you want to quit?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('This will exit the app.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          },
        );

        return true;
      },
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 221, 221, 221),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      ClipPath(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 88, 86, 214),
                                Color.fromARGB(255, 255, 77, 44),
                              ],
                            ),
                          ),
                        ),
                        clipper: CustomClipperCurve(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (conext) {
                                      return AlertDialog(
                                        title:
                                            const Text("Do you want to quit?"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text('This will exit the app.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Yes'),
                                            onPressed: () {
                                              SystemNavigator.pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.output_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 55,
                          ),
                          const Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: const Text(
                              "Login to discover amazing things!",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(232, 186, 187, 187),
                                  offset: Offset(2, 8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 40, bottom: 50),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? "Enter a valid email"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // hintText: 'Enter your username',
                                      labelText: 'Email',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: _obscureText,
                                    controller: passwordController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? "Password cannot be empty"
                                            : null,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 20,
                                        color: Colors.grey,
                                      ),

                                      suffix: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // hintText: 'Enter your username',
                                      labelText: 'Password',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: logIn,
                                    child: const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontSize: 15.8,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        fixedSize: const Size(350, 45),
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        primary: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        onPrimary: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()),
                                    ),
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an Account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => SignUpPage());
                                },
                                child: const Text(
                                  "Create an Account",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              const Divider(
                                indent: 45,
                                endIndent: 45,
                                color: Color.fromARGB(255, 136, 136, 136),
                                thickness: 1,
                              ),
                              Container(
                                color: const Color.fromARGB(255, 221, 221, 221),
                                margin: const EdgeInsets.only(left: 150),
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: const Text(
                                  "Or Login using",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(232, 186, 187, 187),
                                  offset: Offset(8, 8),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar(
                                        "Wait", "Service Currently Unavialable",
                                        backgroundColor:
                                            Color.fromARGB(127, 255, 82, 82),
                                        duration: Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: Image.asset(
                                    "images/facebook.png",
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar(
                                        "Wait", "Service Currently Unavialable",
                                        backgroundColor:
                                            Color.fromARGB(127, 255, 82, 82),
                                        duration: Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: Image.asset(
                                    "images/google.png",
                                    height: 64,
                                    width: 64,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar(
                                        "Wait", "Service Currently Unavialable",
                                        backgroundColor:
                                            Color.fromARGB(127, 255, 82, 82),
                                        duration: Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: Image.asset(
                                    "images/twitter.png",
                                    height: 54,
                                    width: 54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  //-----Login method for firebase-----
  Future logIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) => Get.snackbar(
              "Irasshaimase", "Successfully Loggeed In",
              duration: Duration(seconds: 2)))
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message.toString(), false);
      Get.back();
    }
    //----Navigator.of(context) not working-----
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
