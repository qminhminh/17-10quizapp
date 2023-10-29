import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thutext/helpers/dialogs.dart';
import 'package:thutext/models/user_model.dart';
import 'package:thutext/profile_screen.dart';
import 'package:thutext/widgets/chat_user_card.dart';
import '../../../api/apis.dart';

class BottomChatHSScreen extends StatefulWidget {
  const BottomChatHSScreen({super.key});

  @override
  State<BottomChatHSScreen> createState() => _BottomProfileHSScreenState();
}

class _BottomProfileHSScreenState extends State<BottomChatHSScreen> {
  List<UserModel> list = [];
  // for storing search items
  final List<UserModel> searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSetInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          // ignore: curly_braces_in_flow_control_structures
          APIs.updateActiveStatus(true);
        if (message.toString().contains('pause'))
          // ignore: curly_braces_in_flow_control_structures
          APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name, email.....',
                      ),
                      autofocus: true,
                      style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                      onChanged: (val) {
                        searchlist.clear();

                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            searchlist.add(i);
                          }
                          setState(() {
                            searchlist;
                          });
                        }
                      },
                    )
                  : const Text('Tín nhắn'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: APIs.me,
                                  )));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                child: const Icon(Icons.add_comment_rounded),
                onPressed: () async {
                  _showMessageUpdate();
                },
              ),
            ),
            body: StreamBuilder(
              stream: APIs.getChatId(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Thêm trường hợp ConnectionState.none
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: APIs.getAllUser(
                          snapshot.data!.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            ); // Thêm trường hợp ConnectionState.none
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            if (data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            list = data
                                    ?.map((e) => UserModel.fromJson(e.data()))
                                    .toList() ??
                                [];
                            if (list.isNotEmpty) {
                              return ListView.builder(
                                itemCount: _isSearching
                                    ? searchlist.length
                                    : list.length,
                                padding: const EdgeInsets.only(top: 2),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CharUserCard(
                                      user: _isSearching
                                          ? searchlist[index]
                                          : list[index]);
                                  // return Text('Name: ${list[index].name}'); // Thay thế tên biến phù hợp
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text(
                                'No Connection Found',
                                style: TextStyle(fontSize: 20),
                              ));
                            }
                        }
                      },
                    );
                }
                // return Center(child: CircularProgressIndicator(strokeWidth: 2,),);
              },
            ),
          ),
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          }),
    );
  }

  void _showMessageUpdate() {
    String email = '';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Gửi yêu cầu kết bạn')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (val) => email = val,
                //onSaved: (val)=> updatedMsg = val!,
                decoration: InputDecoration(
                    hintText: 'Email của người...',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    if (email.isNotEmpty)
                      // ignore: curly_braces_in_flow_control_structures
                      await APIs.createNotice('Đã gửi lời mời kết bạn');
                    await APIs.addChatUserChat(email).then((value) {
                      Dialogs.showSnacker(context, 'Gửi thành công');
                    });
                  },
                  child: const Text(
                    'Gửi',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                )
              ],
            ));
  }
}
