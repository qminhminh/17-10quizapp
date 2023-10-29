import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/screen/auth/signup_screen.dart';
import '../../helpers/dialogs.dart';
import '../giaovien_screen/gv_home_screen.dart';
import '../hocsinh_screen/hs_home_screen.dart';
import '../quantri_screen/qt_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var textEmailController = TextEditingController();
  var textPassWordController = TextEditingController();

  Future<UserCredential?> loginEmailandPassword() async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: textEmailController.text,
        password: textPassWordController.text,
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/login.svg"), fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Xin chào',
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Đăng nhập vào tài khoản của bạn',
                      style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                    ),
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
                        controller: textPassWordController,
                        decoration: InputDecoration(
                            hintText: 'Mật khẩu của bạn',
                            prefixIcon: const Icon(
                              Icons.password_outlined,
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
                    Row(
                      children: [
                        Expanded(child: Container()),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()));
                          },
                          child: Text(
                            'Bạn chưa có tài khoản',
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[500]),
                          ),
                        ),
                      ],
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
                  color: Colors.blueAccent
                  // image: DecorationImage(
                  //     image: AssetImage("images/loginbtn.png"),
                  //     fit: BoxFit.cover),
                  ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    String email = textEmailController.text;

                    if (email.contains('hs')) {
                      loginEmailandPassword();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HSHomeScreen()));
                      APIs.prefs.setString('hs', email);
                      Dialogs.showSnacker(context, 'Đăng nhập thành công');
                    }
                    if (email.contains('gv')) {
                      loginEmailandPassword();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GVHomeScreen()));
                      APIs.prefs.setString('gv', email);
                      Dialogs.showSnacker(context, 'Đăng nhập thành công');
                    }
                    if (email.contains('qt')) {
                      loginEmailandPassword();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QTHomeScreen()));
                      APIs.prefs.setString('qt', email);
                      Dialogs.showSnacker(context, 'Đăng nhập thành công');
                    }
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
          ],
        ),
      ),
    );
  }
}
