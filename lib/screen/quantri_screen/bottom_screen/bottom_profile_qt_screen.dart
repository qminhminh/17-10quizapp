import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/user_model.dart';

import '../../../helpers/dialogs.dart';
import '../../../profile_screen.dart';
import '../../../widgets/chat_user_card.dart';

class BottomProfileQTScreen extends StatefulWidget {
  const BottomProfileQTScreen({super.key});

  @override
  State<BottomProfileQTScreen> createState() => _BottomProfileQTScreenState();
}

class _BottomProfileQTScreenState extends State<BottomProfileQTScreen> {

  List<UserModel> list=[];
  // for storing search items
  final List<UserModel> searchlist=[];
  bool _isSearching=false;
  @override
  void initState() {
    super.initState();
    APIs.getSetInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(APIs.auth.currentUser!=null)
      {
        if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
        if(message.toString().contains('pause')) APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: _isSearching ? TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name, email.....',
                ),
                autofocus: true,
                style: TextStyle(fontSize: 16,letterSpacing: 0.5),

                onChanged: (val){
                  searchlist.clear();

                  for(var i in list){
                    if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                      searchlist.add(i);
                    }
                    setState(() {
                      searchlist;
                    });
                  }
                },
              ): Text('Tín nhắn'),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>  ProfileScreen(user: APIs.me,)));
                }, icon: Icon(Icons.more_vert)),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                child: Icon(Icons.add_comment_rounded),
                onPressed: () async{
                  _showMessageUpdate();
                },

              ),
            ),
            body:StreamBuilder(
              stream: APIs.getChatId(),
              builder: (context,snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: APIs.getAllUser(snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator(),); // Thêm trường hợp ConnectionState.none
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            if (data == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                            if(list.isNotEmpty){
                              return ListView.builder(
                                itemCount:_isSearching ? searchlist.length : list.length,
                                padding: EdgeInsets.only(top: 2),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CharUserCard(user:_isSearching ? searchlist[index] : list[index]);
                                  // return Text('Name: ${list[index].name}'); // Thay thế tên biến phù hợp
                                },
                              );
                            }
                            else{
                              return Center(child: Text('No Connection Found',style: TextStyle(fontSize: 20),));
                            }
                        }
                      },
                    );
                }
                // return Center(child: CircularProgressIndicator(strokeWidth: 2,),);

              },
            ) ,

          ),
          onWillPop: (){
            if(_isSearching){
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            }
            else{
              return Future.value(true);
            }
          }
      ),
    );
  }

  void _showMessageUpdate(){
    String email='';
    showDialog(context: context,
        builder: (_)=> AlertDialog(
          contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.person_add,color: Colors.blue,size: 28,),
              Text('  Gửi yêu cầu kết bạn')
            ],
          ),
          content: TextFormField(
            maxLines: null,
            onChanged: (val)=>email=val,
            //onSaved: (val)=> updatedMsg = val!,
            decoration: InputDecoration(
                hintText: 'Email của người...',
                prefixIcon: Icon(Icons.email,color: Colors.blue,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),
          ),
          actions: [

            MaterialButton(
              onPressed: (){ Navigator.pop(context);},
              child: Text('Hủy',style: TextStyle(fontSize: 16,color: Colors.blue),),
            ),

            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);

                if(email.isNotEmpty)
                  await APIs.createNotice('Đã gửi lời mời kết bạn');
                await APIs.addChatUserChat(email).then((value) {
                  Dialogs.showSnacker(context, 'Gửi thành công');
                });
              },
              child: Text('Gửi',style: TextStyle(fontSize: 16,color: Colors.blue),),
            )
          ],
        )
    );
  }
}
