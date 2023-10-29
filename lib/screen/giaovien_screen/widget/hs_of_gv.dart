import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/models/giao_vien/socre_hs_model.dart';
import 'package:thutext/models/quan_tri/malopgv_model.dart';
import 'package:thutext/screen/giaovien_screen/widget/card_score_hs.dart';

class HSOFGv extends StatefulWidget {
  final ClassGVModel model;
  const HSOFGv({super.key, required this.model});

  @override
  State<HSOFGv> createState() => _HSOFGvState();
}

class _HSOFGvState extends State<HSOFGv> {
  List<ScoreHSModel> list = [];
  final List<ScoreHSModel> searchlist = [];
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
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ' email.....',
                      ),
                      autofocus: true,
                      style: const TextStyle(fontSize: 16, letterSpacing: 0.5),
                      onChanged: (val) {
                        searchlist.clear();

                        for (var i in list) {
                          if (i.email
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
                  : const Text('Điểm tất cả học sinh'),
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
              stream: APIs.getAllHSMaHP(widget.model.mahhp),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => ScoreHSModel.fromJson(e.data()))
                              .toList() ??
                          [];
                      return ListView.builder(
                          itemCount:
                              _isSearching ? searchlist.length : list.length,
                          itemBuilder: (context, index) {
                            return CardSordHS(
                              model: _isSearching
                                  ? searchlist[index]
                                  : list[index],
                            );
                          });
                    } else {
                      return const Center(child: Text('Không có dữ liệu'));
                    }
                  default:
                    return const Center(child: Text('Không có dữ liệu'));
                }
              },
            ),
          ),
        ));
  }
}
