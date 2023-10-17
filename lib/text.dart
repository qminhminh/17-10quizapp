//
// import 'package:flutter/material.dart';
// import 'package:thutext/api/apis.dart';
// import '../../../models/hoc_sinh/score_model.dart';
//
//
// class BottomHomeHSScreen extends StatefulWidget {
//   const BottomHomeHSScreen({super.key});
//
//   @override
//   State<BottomHomeHSScreen> createState() => _BottomHomeHSScreenState();
// }
//
// class _BottomHomeHSScreenState extends State<BottomHomeHSScreen> {
//   //List<QuestionModel> list = [];
//   int totalScore = 0;
//   List<ScoreModel> listScore = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     getDataFromFirestore();
//   }
//
//   Future<void> getDataFromFirestore() async {
//     final querySnapshot = await APIs.firestore.collection('scoreusers').get();
//     final scoreList = querySnapshot.docs
//         .map((doc) => ScoreModel.fromJson(doc.data()))
//         .toList();
//
//     setState(() {
//       listScore = scoreList;
//
//       for (var score in listScore) {
//         totalScore += score.score;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Question Text'),
//         leading:  Text('Total : $totalScore'),
//         automaticallyImplyLeading: false,
//       ),
//       body: StreamBuilder(
//           stream: APIs.getPostQuestion(),
//           builder: (context,snapshot){
//             switch(snapshot.connectionState){
//               case ConnectionState.waiting:
//               case ConnectionState.none:
//                 return Center(child: CircularProgressIndicator(),);
//               case ConnectionState.active:
//               case ConnectionState.done:
//
//                 final data = snapshot.data!.docs;
//                 // list = data!.map((e) => QuestionModel.fromJson(e.data())).toList() ?? [];
//                 return ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     // itemCount: list.length,
//                     itemBuilder: (context ,index){
//                       // return QuestionCardScreen(model: list[index], index: index);
//                     }
//                 );
//             }
//           }
//       ),
//     );
//   }
// }
