
import 'dart:io';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/view_profile_screen.dart';
import 'package:thutext/widgets/message_card.dart';
import '../api/apis.dart';
import '../helpers/my_date_uti.dart';
import '../main.dart';
import '../models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list=[];
  final textController=TextEditingController();
  bool _showEmoji=false,_isLoading=false,checkSearch=false;
  final  List<Message> searchlist=[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if(_showEmoji){
              setState(() {
                _showEmoji = !_showEmoji;

                if(checkSearch)
                checkSearch!=checkSearch;
              });
              return Future.value(false);
            }
            else{
              return Future.value(true);
            }



          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
             // flexibleSpace: _appBar(),
              title: checkSearch ?  TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ' Search Text...',
                ),
                autofocus: true,
                style: TextStyle(fontSize: 16,letterSpacing: 0.5),
                //when search text changes then updatesd search list
                onChanged: (val){
                  searchlist.clear();

                  for(var i in list){
                    if(i.msg.toLowerCase().contains(val.toLowerCase())){
                      searchlist.add(i);
                    }
                    setState(() {
                      searchlist;
                    });
                  }
                },
              ) : _appBar(),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        checkSearch = !checkSearch;
                      });
                    }, icon: Icon(checkSearch ? CupertinoIcons.clear_circled_solid : Icons.search)),
                // CALL ID
                IconButton(
                    onPressed: (){

                        String id='';
                        showDialog(context: context,
                            builder: (_)=> AlertDialog(
                              contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Row(
                                children: [
                                  Icon(Icons.person_add,color: Colors.blue,size: 28,),
                                  Text('  Add Call ID')
                                ],
                              ),
                              content: TextFormField(
                                maxLines: null,
                                onChanged: (val)=>id=val,
                                //onSaved: (val)=> updatedMsg = val!,
                                decoration: InputDecoration(
                                    hintText: 'Call Id',
                                    prefixIcon: Icon(Icons.email,color: Colors.blue,),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),
                              actions: [

                                MaterialButton(
                                  onPressed: (){ Navigator.pop(context);},
                                  child: Text('Cancle',style: TextStyle(fontSize: 16,color: Colors.blue),),
                                ),

                                MaterialButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                     if(id.isNotEmpty){
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallPage(callID: id, chatUser: widget.user,)));
                                       APIs.sendPudNOtification(widget.user, "Call message . Do You Have Listen :  $id");
                                       APIs.sendMessage(widget.user,"Id Call:  $id", Type.text);
                                     }
                                  },
                                  child: Text('Call Now',style: TextStyle(fontSize: 16,color: Colors.blue),),
                                )
                              ],
                            )
                        );

                    },
                    icon: Icon(Icons.video_call,color: Colors.black87,)
                )
              ],
            ),
            backgroundColor: Colors.blue.shade50,
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return SizedBox(); // Thêm trường hợp ConnectionState.none
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                         list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                          if(list.isNotEmpty){
                            return ListView.builder(
                              reverse: true,
                              itemCount:checkSearch? searchlist.length : list.length,
                              padding: EdgeInsets.only(top: 601),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                               // return CharUserCard(user:_isSearching ? searchlist[index] : list[index]);
                                 return MessageCard(message:checkSearch ? searchlist[index] : list[index],); // Thay thế tên biến phù hợp
                              },
                            );
                          }
                          else{
                            return Center(child: Text('Say Hii 👋',style: TextStyle(fontSize: 20),));
                          }
                      }
                    },
                  ),
                ),

                // if(textController.text.isNotEmpty )
                // Container(
                //
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //       child: Text('            Composing message.....',style: TextStyle(color: Colors.black87),)
                //   ),
                // ),

                if(_isLoading)
                Align(
                  alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2,),
                    )),


                _chatInput(),


                if(_showEmoji)
                SizedBox(
                  height: 35,
                  child: EmojiPicker(
                    textEditingController: textController,
                    config: Config(
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                  onPressed: ()=>Navigator.pop(context),
                  icon: Icon(Icons.arrow_back,color: Colors.black54,),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),  // You need to have 'mq' defined
                child: CachedNetworkImage(
                  width: 4,
                  height: 4,
                  imageUrl:list.isNotEmpty ? list[0].image : widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              SizedBox(width: 10,),
              SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user name
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),

                  SizedBox(height: 3,),

                  // user about
                  Text(
                    list.isNotEmpty ? list[0].isOnline ? 'Online 📍': 'Offline 📍' : 'Offline 📍',
                    style: TextStyle(fontSize: 13,color: Colors.black54,fontWeight: FontWeight.w500),),

                ],
              ),
              //SizedBox(width: 30,),


            ],
          );
        }
      ),
    );
  }
  // bottom chat input feild
  Widget _chatInput(){
     return Padding(
       padding: EdgeInsets.symmetric(vertical: 1,horizontal: 2),
       child: Row(
         children: [
           Expanded(
             child: Card(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
               child: Row(
                 children: [

                   // emoji button
                   IconButton(
                     onPressed: (){
                       setState(() {
                         FocusScope.of(context).unfocus();
                         _showEmoji = !_showEmoji;
                       });
                     },
                     icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,size: 20,),
                   ),


                   // text feld
                    Expanded(
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                         onTap: (){
                            if(_showEmoji) _showEmoji = !_showEmoji;
                         },

                         decoration: InputDecoration(hintText: 'Type...',hintStyle: TextStyle(color: Colors.blueAccent),border: InputBorder.none),

                    )),

                   // pick iamge from camera button
                   IconButton(
                     onPressed: () async {
                       final ImagePicker picker = ImagePicker();
                       try {
                         final List<XFile>? images = await picker.pickMultiImage(
                           imageQuality: 70,
                         );
                         for(var i in images!){
                           setState(() {
                             _isLoading = true;
                           });
                             await APIs.sendChatImage(widget.user, File(i.path));
                           setState(() {
                             _isLoading = false;
                           });
                         }


                       } catch (error) {
                         print("Error: $error");
                       }
                     },
                     icon: Icon(Icons.image, color: Colors.blueAccent, size: 26),
                   ),

                   IconButton(
                     onPressed: () async {
                       final ImagePicker picker = ImagePicker();
                       try {
                         final XFile? image = await picker.pickImage(
                           source: ImageSource.camera,
                           imageQuality: 70,
                         );

                         if (image != null) {
                           await APIs.sendChatImage(widget.user, File(image.path));
                         }
                       } catch (error) {
                         print("Error: $error");
                       }
                     },
                     icon: Icon(Icons.camera_alt_rounded,color: Colors.blueAccent,size: 26,),
                   ),
                   // take image from camera
                 ],

               ),
             ),
           ),

           // sent message button
           MaterialButton(
               onPressed: (){
                 if(textController.text.isNotEmpty){
                  // setState(() {
                  //   checkText=true;
                  // });
                   if(list.isEmpty){
                     APIs.sendFirstMessage(
                         widget.user, textController.text, Type.text);
                   }
                   else {
                     APIs.sendMessage(
                         widget.user, textController.text, Type.text);
                   }
                   textController.text='';

                 }

               },
             minWidth: 0,
             padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
             shape: CircleBorder(),
             color: Colors.lightBlueAccent,
             child: Icon(Icons.send,color: Colors.black,size: 28,),
           ),
         ],
       ),
     );
  }
}
