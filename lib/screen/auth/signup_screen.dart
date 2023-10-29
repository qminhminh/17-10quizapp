import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thutext/screen/auth/login_screen.dart';
import '../../api/apis.dart';
import '../../helpers/dialogs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List images = ["g.png", "t.png", "f.png"];
  var textEmailController = TextEditingController();
  var textPasswordController = TextEditingController();

  Future<UserCredential?> registerEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: textEmailController.text,
        password: textPasswordController.text,
      );
    } catch (e) {
      print('${e}');
      Dialogs.showSnacker(context, 'Something went Wrong Check Internet');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("images/signup.png"),
              //       fit: BoxFit.cover),
              // ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.white70,
                  //   radius: 60,
                  //   backgroundImage: AssetImage("images/profile.png"),
                  // ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 37,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 7,
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(1, 1),
                            ),
                          ]),
                      child: TextField(
                        controller: textEmailController,
                        decoration: InputDecoration(
                            hintText: 'Email của bạn',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 7,
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(1, 1),
                            ),
                          ]),
                      child: TextField(
                        controller: textPasswordController,
                        decoration: InputDecoration(
                            hintText: 'Password của bạn',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueAccent,
                // image: DecorationImage(
                //     image: AssetImage("images/loginbtn.png"),
                //     fit: BoxFit.cover
                // ),
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    final userCredential = await registerEmailAndPassword();
                    if (userCredential != null) {
                      // Registration was successful
                      String email = textEmailController.text;
                      String pass = textPasswordController.text;

                      if (email.contains('hs')) {
                        // You can add additional logic here for different types of users
                        APIs.createUser(email, 0, pass);
                      } else if (email.contains('gv')) {
                        APIs.createUser(email, 1, pass);
                      } else if (email.contains('qt')) {
                        APIs.createUser(email, 2, pass);
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                      // ignore: use_build_context_synchronously
                      Dialogs.showSnacker(context, 'Registration successful.');
                    }
                  },
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: RichText(
                  text: const TextSpan(
                      text: 'Đăng xuất',
                      style: TextStyle(fontSize: 24, color: Colors.black))),
            ),
            const SizedBox(
              height: 50,
            ),
            RichText(
                text: TextSpan(
              text: "Đăng ký bằng một trong các phương pháp sau ",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: List<Widget>.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey[500],
                    child: CircleAvatar(
                      radius: 25,
                      // ignore: prefer_interpolation_to_compose_strings
                      backgroundImage: AssetImage('images/' + images[index]),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
