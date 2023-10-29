import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/hoc_sinh/notice_score.dart';
import 'package:thutext/screen/hocsinh_screen/widget/list_socre_card_hs.dart';

class BottomScoreHSScreens extends StatefulWidget {
  const BottomScoreHSScreens({super.key});

  @override
  State<BottomScoreHSScreens> createState() => _BottomScoreHSScreensState();
}

class _BottomScoreHSScreensState extends State<BottomScoreHSScreens> {
  List<NoticeScoreHSModel> list = [];
  final List<NoticeScoreHSModel> searchlist = [];
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
                      hintText: 'Ma hoc phan, email.....',
                    ),
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                    onChanged: (val) {
                      searchlist.clear();

                      for (var i in list) {
                        if (i.mahp.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          searchlist.add(i);
                        }
                        setState(() {
                          searchlist;
                        });
                      }
                    },
                  )
                : const Text('Điểm thi'),
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
            stream: APIs.getAllSocreME(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list = data
                          ?.map((e) => NoticeScoreHSModel.fromJson(e.data()))
                          .toList() ??
                      [];
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _isSearching ? searchlist.length : list.length,
                      itemBuilder: (context, index) {
                        return ScoreCardHs(
                          model: _isSearching ? searchlist[index] : list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
