
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thutext/models/giao_vien/create_description_model.dart';
import 'package:thutext/models/giao_vien/create_question_model.dart';
import 'package:thutext/models/hoc_sinh/score_model.dart';
import 'package:thutext/models/user_model.dart';


class APIs{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late CreateDescriptMode medes;


  // tạo tài khoản cho người dùng
  static Future<void> createUser(String email, int a) async {
    try{
      final userModel = UserModel(
          id: auth.currentUser!.uid,
          name: "",
          image: "",
          email: email,
          checkuser: a
      );
      return await firestore.collection("users").doc(auth.currentUser!.uid).set(userModel.toJson());

    }
     catch(e){
      print('$e');
      return null;
     }

  }


  // thêm sinh viên cho giáo viên
  static Future<void> addChatUser(List<String> emailHS, String emailGV, String mahp) async{

    for (String email in emailHS) {
      final dataHS= await firestore.collection('users').where('email',isEqualTo:email).get();
      final dataGV= await firestore.collection('users').where('email',isEqualTo:emailGV).get();

      if(dataHS.docs.isNotEmpty && dataHS.docs.first.id != user.uid ){

        // thme id
        await firestore.collection('users')
            .doc(dataGV.docs.first.id)
            .collection('my_users')
            .doc(dataHS.docs.first.id)
            .set({});

        await firestore.collection('users')
            .doc(dataHS.docs.first.id)
            .collection('my_users')
            .doc(dataGV.docs.first.id)
            .set({});

        // them ma hoc phan
        await firestore.collection('users')
            .doc(dataGV.docs.first.id)
            .collection('ma_hp')
            .doc(mahp)
            .set({});
        await firestore.collection('users')
            .doc(dataHS.docs.first.id)
            .collection('ma_hp')
            .doc(mahp)
            .set({});

      }else{

      }
    }

  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getMaHPId(){
    return firestore.collection('users')
        .doc(user.uid)
        .collection('ma_hp')
        .snapshots();
  }
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllQuestion(List<String> mahp){

    return firestore.collection('createquesanddes')
        .where('subject_code',whereIn: mahp)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getPostQuestion() {
    return firestore.collection('userspost').snapshots();
  }


  static Future<void> createScore(int a,String mahp) async {
    final time=DateTime.now().millisecondsSinceEpoch.toString();

    try{
      final user = auth.currentUser;

        final userModel = ScoreModel(id: user!.uid, score: a, time: time);
        return await firestore.collection("scoreusers")
                     .doc(user!.uid).collection(mahp)
                     .doc(time).set(userModel.toJson());

    }
    catch(e){
      print('$e');
      return null;
    }

  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getSocreuser() {
    return firestore.collection('scoreusers').snapshots();
  }


  // tao cau hoi vaf cau rta loi
  static Future<void> createDescripton(String image,String description,String count,String subcode, String timeQues,String namesubject, String timetext,String our, String minus) async {

    try{
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
          minus: minus
      );
      return await firestore.collection("createquesanddes").doc(user!.uid+subcode).set(userModel.toJson());

    }
    catch(e){
      print('$e');
      return null;
    }

  }

  // tạo câu tar lời
  static Future<void> createQuestionandAnswer(String op1,String op2,String op3,String op4,String opcorrcet,String question, String namesubject,String subjectcode) async {
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    try{
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
          time: time
      );
      return await firestore.collection("createquesanddes").doc(user!.uid+subjectcode).collection(subjectcode).doc(time).set(userModel.toJson());

    }
    catch(e){
      print('$e');
      return null;
    }

  }
  //lấy mô tả
  static Stream<QuerySnapshot<Map<String,dynamic>>> getDesCriptQues() {
    return firestore.collection('createquesanddes').snapshots();
  }

   //lấy câu hỏi
  static Stream<QuerySnapshot<Map<String,dynamic>>> getQuestion(String mahp,String id) {
    return firestore.collection('createquesanddes').doc(id+mahp).collection(mahp).snapshots();
  }


  // update picture info
  static Future<void> updateProfilePicture(File file, String mahp) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref = firebaseStorage.ref().child('profile_pictures/${user.uid + mahp}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      // You can optionally handle any post-upload tasks here
    });

    // Do not update the 'image' field in CreateDescriptMode
    // Instead, update the 'image' field directly in Firestore
    await firestore.collection('createquesanddes').doc(user.uid + mahp).update({
      'image': await ref.getDownloadURL(),
    });
  }

  // update descrtiption
  static Future<void> userUpdateDesCriptionGV(String description,String count,String subcode, String timeQues,String namesubject, String timetext,String our, String minus) async{
    await firestore.collection('createquesanddes').doc(user.uid + subcode).update({
      'minus': minus,
      'our':our,
      'namesubject': namesubject,
      'subject_code': subcode,
      'count_ques':count,
      'description':description,
      'time_ques':timeQues,
       'timetext': timetext

    });
  }

  // uupdate quaestion
  static Future<void> userUpdateQuestionnGV(String subcode,String time,String question, String optin1,String optin2,String optin3,String optin4,String optionchoose ) async{

    await firestore.collection("createquesanddes").doc(user!.uid+subcode).collection(subcode).doc(time).update({
          'option1' : optin1,
          'option2' : optin2,
           'option3': optin3,
           'option4':optin4,
           'optioncorrect': optionchoose,
            'question':question
    });
  }


  // delete question and answers
  static Future<void> gedeleteQuestionGV(String time, String subjectcode) async{
    await firestore.collection('createquesanddes')
        .doc(user!.uid+subjectcode)
        .collection(subjectcode)
        .doc(time)
        .delete();
  }


  // delete description
  static Future<void> gedeleteDesCriptionGV(String subjectcode) async{
    await firestore.collection('createquesanddes')
        .doc(user!.uid+subjectcode)
        .delete();

  }

  // get user student and teacher
  static Stream<QuerySnapshot<Map<String,dynamic>>> getUser() {
    return firestore.collection('users').snapshots();
  }

  // // delete user
  static Future<void> gedeleteUserQT(String email, String id) async{

    await firestore.collection('users')
        .doc(id)
        .delete();

  }

  // delete account
  static Future<void> gedeleteUser(String id) async{
     try{
       // await FirebaseAuth.instance
     } on FirebaseAuthException catch (e) {
       if (e.code == 'requires-recent-login') {
         print('The user must reauthenticate before this operation can be executed.');
       }
     }

  }
}