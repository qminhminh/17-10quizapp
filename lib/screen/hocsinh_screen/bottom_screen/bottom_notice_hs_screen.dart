import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/loader.dart';
import 'package:thutext/models/notice_model.dart';
import 'package:thutext/widgets/notice_card.dart';

class BottomNoticeHSScreen extends StatefulWidget {
  const BottomNoticeHSScreen({super.key});

  @override
  State<BottomNoticeHSScreen> createState() => _BottomNoticeHSScreenState();
}

class _BottomNoticeHSScreenState extends State<BottomNoticeHSScreen> {
  List<NoticeModel> list = [];
  // for storing search items
  final List<NoticeModel> searchlist = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
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
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          searchlist.add(i);
                        }
                        setState(() {
                          searchlist;
                        });
                      }
                    },
                  )
                : const Text('Thông báo'),
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
            ],
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
                    stream: APIs.getAllNOticeUser(
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
                                  ?.map((e) => NoticeModel.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return list == null
                                ? const Loader()
                                : list.isEmpty
                                    ? const Center(
                                        child: Text('No messages available'))
                                    : ListView.builder(
                                        itemCount: _isSearching
                                            ? searchlist.length
                                            : list.length,
                                        padding: const EdgeInsets.only(top: 2),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return NoticeCard(
                                            noteMod: _isSearching
                                                ? searchlist[index]
                                                : list[index],
                                          );
                                          // return Text('Name: ${list[index].name}'); // Thay thế tên biến phù hợp
                                        },
                                      );
                          } else {
                            return const Center(
                                child: Text(
                              'Chưa có thông báo nào',
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
      ),
    );
  }
}
