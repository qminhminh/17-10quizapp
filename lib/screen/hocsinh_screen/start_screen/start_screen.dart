import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../list_question/list_hs_question.dart';
import '../../../models/giao_vien/create_description_model.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.model});
  final CreateDescriptMode model;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final targetTime = DateFormat('dd/MM/yyyy').parse(widget.model.timetext);
    final our =  targetTime.add(Duration(hours: int.parse(widget.model.our), minutes: int.parse(widget.model.minus)));

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Môn: ',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold)),
                  Text(widget.model.namesubject,style: TextStyle(fontSize: 18),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ngày làm bài: ', style: TextStyle(fontSize: 17),),
                  Text('${widget.model.timetext}',style:TextStyle(fontSize: 17),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Giờ bắt đàu làm bài: ', style: TextStyle(fontSize: 17),),
                  Text('${widget.model.our} : ${widget.model.minus}',style:TextStyle(fontSize: 17),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Thời gian làm bài -: ', style: TextStyle(fontSize: 17),),
                  Text('${(int.parse(widget.model.timeQues)/60).ceil()} phút',style:TextStyle(fontSize: 17),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lưu ý: ', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  Text('${widget.model.description}',style:TextStyle(fontSize: 17),)
                ],
              ),


              TextButton(
                  onPressed: (){
                    if(now.isAfter(our)){
                      showDialog(context: context,
                          builder: (_)=> AlertDialog(
                            contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: Row(
                              children: [
                                Text('Sẵn sàng làm bài ')
                              ],
                            ),

                            actions: [

                              MaterialButton(
                                onPressed: (){ Navigator.pop(context);},
                                child: Text('Quay lại',style: TextStyle(fontSize: 16,color: Colors.blue),),
                              ),

                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => ListQuestionHSScreen(model: widget.model)));
                                },
                                child: Text('Bắt đầu',style: TextStyle(fontSize: 16,color: Colors.blue),),
                              )
                            ],
                          )
                      );

                    }
                    else{
                      showDialog(context: context,
                          builder: (_)=> AlertDialog(
                            contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: Row(
                              children: [
                                Text('Chưa tới thời gian làm bài ')
                              ],
                            ),

                            actions: [

                              MaterialButton(
                                onPressed: (){ Navigator.pop(context);},
                                child: Text('Quay lại',style: TextStyle(fontSize: 16,color: Colors.blue),),
                              ),

                              MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                },
                                child: Text('',style: TextStyle(fontSize: 16,color: Colors.blue),),
                              )
                            ],
                          )
                      );
                    }
                  },
                  child: Text('Bắt đầu làm', style: TextStyle(fontSize: 19),)
              )
            ],
          ),
        ),
      ),
    );
  }
}
