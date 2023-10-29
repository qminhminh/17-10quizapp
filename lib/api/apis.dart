import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thutext/models/giao_vien/create_description_model.dart';
import 'package:thutext/models/giao_vien/create_question_model.dart';
import 'package:thutext/models/hoc_sinh/score_model.dart';
import 'package:thutext/models/notice_model.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;
  static SharedPreferences prefs =
      SharedPreferences.getInstance() as SharedPreferences;
  static User get user => auth.currentUser!;
  static late CreateDescriptMode medes;
  static late UserModel me;

  // tạo tài khoản cho người dùng
  static Future<void> createUser(String email, int a, String pass) async {
    try {
      final userModel = UserModel(
          id: auth.currentUser!.uid,
          name: "",
          image: "",
          email: email,
          checkuser: a,
          about: '',
          pushtoken: '',
          isOnline: false,
          password: pass);
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set(userModel.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  // // tạo tài khoản cho người dùng
  // static Future<void> createUserNotice(String email, int a) async {
  //   try {
  //     final userModel = UserModel(
  //         id: auth.currentUser!.uid,
  //         name: "",
  //         image: "",
  //         email: email,
  //         checkuser: a,
  //         about: '',
  //         pushtoken: '',
  //         isOnline: false);
  //     return await firestore
  //         .collection("users")
  //         .doc(auth.currentUser!.uid)
  //         .set(userModel.toJson());
  //   } catch (e) {
  //     print('$e');
  //     return null;
  //   }
  // }

  static Future<bool> addChatUserChat(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('chat')
          .doc(data.docs.first.id)
          .set({});

      await firestore
          .collection('users')
          .doc(data.docs.first.id)
          .collection('chat')
          .doc(user.uid)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  // thêm sinh viên cho giáo viên
  static Future<void> addChatUser(
      List<String> emailHS, String emailGV, String mahp, String monhoc) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final classModel = ClassGVModel(time: time, tenmon: monhoc, mahhp: mahp);
    final dagv = await firestore
        .collection('users')
        .where('email', isEqualTo: emailGV)
        .get();

    await firestore
        .collection('classgv')
        .doc(dagv.docs.first.id)
        .collection('ma')
        .doc(time)
        .set(classModel.toJson());
    for (String email in emailHS) {
      final dataHS = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      final dataGV = await firestore
          .collection('users')
          .where('email', isEqualTo: emailGV)
          .get();

      if (dataHS.docs.isNotEmpty && dataHS.docs.first.id != user.uid) {
        // thme id
        await firestore
            .collection('users')
            .doc(dataGV.docs.first.id)
            .collection('my_users')
            .doc(dataHS.docs.first.id)
            .set({});

        await firestore
            .collection('users')
            .doc(dataHS.docs.first.id)
            .collection('my_users')
            .doc(dataGV.docs.first.id)
            .set({});

        // them ma hoc phan
        await firestore
            .collection('users')
            .doc(dataGV.docs.first.id)
            .collection('ma_hp')
            .doc(mahp)
            .set({});
        await firestore
            .collection('users')
            .doc(dataHS.docs.first.id)
            .collection('ma_hp')
            .doc(mahp)
            .set({});
      } else {}
    }
  }

  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConvertsationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static String getConvertsationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';
  // for getting all users from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMonOFGV() {
    return firestore
        .collection('classgv')
        .doc(user!.uid)
        .collection('ma')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllNOticeUser(
      List<String> userIds) {
    return firestore
        .collection('notice')
        .where('id', whereIn: userIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConvertsationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // delete messgae
  static Future<void> gedeleteMessa(Message message) async {
    await firestore
        .collection('chats/${getConvertsationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image)
      // ignore: curly_braces_in_flow_control_structures
      firebaseStorage.refFromURL(message.msg).delete();
  }

  // update mess
  // ignore: non_constant_identifier_names
  static Future<void> UpdateMessa(Message message, String updateMsg) async {
    await firestore
        .collection('chats/${getConvertsationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({"msg": updateMsg});
  }

  // update read sttus of messgae
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConvertsationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // for getting specific user infoau
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel chuser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chuser.id)
        .snapshots();
  }

  // send chat img
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = firebaseStorage.ref().child(
        'images/${getConvertsationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    //update iamge in firebase
    final imagUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imagUrl, Type.image);
  }

  // for update uer
  static Future<void> sendFirstMessage(
      UserModel chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('chat')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for sending message
  static Future<void> sendMessage(
      UserModel chatuser, String msg, Type type) async {
    // message time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // messgae to send
    final Message message = Message(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConvertsationID(chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPudNOtification(chatuser, type == Type.text ? msg : 'img'));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('chat')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getNoticeId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> gedeleteNotice(String date) async {
    await firestore.collection('notice').doc(date).delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMaHPId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('ma_hp')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllQuestion(
      List<String> mahp) {
    return firestore
        .collection('createquesanddes')
        .where('subject_code', whereIn: mahp)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPostQuestion() {
    return firestore.collection('userspost').snapshots();
  }

  static Future<void> createScore(int a, String mahp) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final user = auth.currentUser;

      final userModel = ScoreModel(id: user!.uid, score: a, time: time);
      return await firestore
          .collection("scoreusers")
          .doc(user!.uid)
          .collection(mahp)
          .doc(time)
          .set(userModel.toJson());
    } catch (e) {
      print('$e');
      // ignore: avoid_returning_null_for_void
      return null;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSocreuser() {
    return firestore.collection('scoreusers').snapshots();
  }

  // tao cau hoi vaf cau rta loi
  static Future<void> createDescripton(
      String image,
      String description,
      String count,
      String subcode,
      String timeQues,
      String namesubject,
      String timetext,
      String our,
      String minus) async {
    try {
      final user = auth.currentUser;

      final userModel = CreateDescriptMode(
          id: user!.uid,
          countQues: count,
          description: description,
          subjectcode: subcode,
          image: image,
          timeQues: timeQues,
          namesubject: namesubject,
          timetext: timetext,
          our: our,
          minus: minus);
      return await firestore
          .collection("createquesanddes")
          .doc(user!.uid + subcode)
          .set(userModel.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  // tạo câu tar lời
  static Future<void> createQuestionandAnswer(
      String op1,
      String op2,
      String op3,
      String op4,
      String opcorrcet,
      String question,
      String namesubject,
      String subjectcode) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final user = auth.currentUser;

      final userModel = QuestionModel(
          id: user!.uid,
          option1: op1,
          option2: op2,
          option3: op3,
          option4: op4,
          optioncorrect: opcorrcet,
          question: question,
          subjectcode: subjectcode,
          time: time);
      return await firestore
          .collection("createquesanddes")
          .doc(user!.uid + subjectcode)
          .collection(subjectcode)
          .doc(time)
          .set(userModel.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  // tạo câu tar lời
  static Future<void> createNotice(String nd) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final user = auth.currentUser;

      final noticeModel = NoticeModel(
          id: user!.uid,
          des: nd,
          time: time,
          name: me.name,
          email: me.email,
          image: me.image);
      return await firestore
          .collection("notice")
          .doc(time)
          .set(noticeModel.toJson());
    } catch (e) {
      print('$e');
      return null;
    }
  }

  //lấy mô tả
  static Stream<QuerySnapshot<Map<String, dynamic>>> getDesCriptQues() {
    return firestore.collection('createquesanddes').snapshots();
  }

  //lấy câu hỏi
  static Stream<QuerySnapshot<Map<String, dynamic>>> getQuestion(
      String mahp, String id) {
    return firestore
        .collection('createquesanddes')
        .doc(id + mahp)
        .collection(mahp)
        .snapshots();
  }

  // update picture info
  static Future<void> updateProfilePictureUsers(File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref =
        firebaseStorage.ref().child('profile_uers/${user.uid + ext}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // You can optionally handle any post-upload tasks here
    });

    // Do not update the 'image' field in CreateDescriptMode
    // Instead, update the 'image' field directly in Firestore
    await firestore.collection('users').doc(user.uid).update({
      'image': await ref.getDownloadURL(),
    });
  }

  // for update uer
  static Future<void> userUpdateInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // update picture info
  static Future<void> updateProfilePicture(File file, String mahp) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref =
        firebaseStorage.ref().child('profile_pictures/${user.uid + mahp}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // You can optionally handle any post-upload tasks here
    });

    // Do not update the 'image' field in CreateDescriptMode
    // Instead, update the 'image' field directly in Firestore
    await firestore.collection('createquesanddes').doc(user.uid + mahp).update({
      'image': await ref.getDownloadURL(),
    });
  }

  // update descrtiption
  static Future<void> userUpdateDesCriptionGV(
      String description,
      String count,
      String subcode,
      String timeQues,
      String namesubject,
      String timetext,
      String our,
      String minus) async {
    await firestore
        .collection('createquesanddes')
        .doc(user.uid + subcode)
        .update({
      'minus': minus,
      'our': our,
      'namesubject': namesubject,
      'subject_code': subcode,
      'count_ques': count,
      'description': description,
      'time_ques': timeQues,
      'timetext': timetext
    });
  }

  // uupdate quaestion
  static Future<void> userUpdateQuestionnGV(
      String subcode,
      String time,
      String question,
      String optin1,
      String optin2,
      String optin3,
      String optin4,
      String optionchoose) async {
    await firestore
        .collection("createquesanddes")
        .doc(user!.uid + subcode)
        .collection(subcode)
        .doc(time)
        .update({
      'option1': optin1,
      'option2': optin2,
      'option3': optin3,
      'option4': optin4,
      'optioncorrect': optionchoose,
      'question': question
    });
  }

  // delete question and answers
  static Future<void> gedeleteQuestionGV(
      String time, String subjectcode) async {
    await firestore
        .collection('createquesanddes')
        .doc(user!.uid + subjectcode)
        .collection(subjectcode)
        .doc(time)
        .delete();
  }

  // delete description
  static Future<void> gedeleteDesCriptionGV(String subjectcode) async {
    await firestore
        .collection('createquesanddes')
        .doc(user!.uid + subjectcode)
        .delete();
  }

  // get user student and teacher
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection('users').snapshots();
  }

  // // delete user
  static Future<void> gedeleteUserQT(String email, String id) async {
    await firestore.collection('users').doc(id).delete();
  }

  // delete account
  static Future<void> gedeleteUser(String id) async {
    try {
      // await FirebaseAuth.instance
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  // update push token and online
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_Online': isOnline,
      'push_token': me.pushtoken,
    });
  }

  // get current user info
  static Future<void> getSetInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      // kiem tra nguoi dung co ton tai khong
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFiMesaingToken();
        APIs.updateActiveStatus(true);
      } else {
        //await createUser().then((value) => getSetInfo());
      }
    });
  }

  // for checking if user exixts or not?
  static Future<bool> userExixts() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // get current user info
  static Future<void> getFiMesaingToken() async {
    await fmessaging.requestPermission();

    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushtoken = t;
        log('Token : $t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendPudNOtification(
      UserModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushtoken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
          "android_channel_id": "Chats",
          "data": {
            "some_data": "User ID: ${me.id}",
          },
        }
      };

      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAR1n9Jj0:APA91bGoLdBnpMnuSz7Gk4l2WoZgGBLUJMVQHOsmVHbDFD3ChToY-t_PWNCDYE9oJWHqOn3lcj9lQc8Cfidg6ct03JEi1L7Wpc2IYYmjI3KXgDfVaMRqhiOOFFhNoQPP2T_xrDbHqnLB'
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\n: ${e.toString()}');
    }
  }
}
