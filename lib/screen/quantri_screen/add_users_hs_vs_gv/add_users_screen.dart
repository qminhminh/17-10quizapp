import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';

class QTAddUsersScreen extends StatefulWidget {
  const QTAddUsersScreen({super.key});

  @override
  State<QTAddUsersScreen> createState() => _QTAddUsersScreenState();
}

class _QTAddUsersScreenState extends State<QTAddUsersScreen> {
  var textEmailHSController = TextEditingController();
  var textEmailGVController = TextEditingController();
  var mahocphanController = TextEditingController();
  var tenmonhocphanController = TextEditingController();
  List<String> emailList = [];

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
                      'Hãy thêm sinh viên cho giáo viên',
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
                        controller: textEmailHSController,
                        decoration: InputDecoration(
                            hintText: 'Email học sinh',
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
                        controller: textEmailGVController,
                        decoration: InputDecoration(
                            hintText: 'Email giáo viên',
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
                        controller: tenmonhocphanController,
                        decoration: InputDecoration(
                            hintText: 'Tên môn học:',
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
                        controller: mahocphanController,
                        decoration: InputDecoration(
                            hintText: 'Mã học phần',
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
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Text(
                          '',
                          style:
                              TextStyle(fontSize: 17, color: Colors.grey[500]),
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
                    if (textEmailHSController.text.isNotEmpty &&
                        textEmailGVController.text.isNotEmpty) {
                      // Thêm địa chỉ email vào danh sách
                      List<String> emailHSList =
                          textEmailHSController.text.split(',');
                      emailList.addAll(emailHSList);

                      APIs.addChatUser(
                          emailList,
                          textEmailGVController.text,
                          mahocphanController.text,
                          tenmonhocphanController.text);
                      // Xóa nội dung trường địa chỉ email sau khi thêm vào danh sách
                      //textEmailHSController.clear();
                    }
                    // In danh sách email
                    print(emailList);
                  },
                  child: const Text(
                    'Thêm',
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
