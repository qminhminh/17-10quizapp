import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/loader.dart';
import 'package:thutext/screen/giaovien_screen/create_question/create_question_screen.dart';
import '../../../models/giao_vien/create_description_model.dart';
import '../../../widgets/descript_giaoviden_ques.dart';

class BottomHomeGVcreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const BottomHomeGVcreen({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomHomeGVScreenState createState() => _BottomHomeGVScreenState();
}

class _BottomHomeGVScreenState extends State<BottomHomeGVcreen> {
  List<CreateDescriptMode> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các môn'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateQuestionGVScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateQuestionGVScreen()),
                    );
                  },
                  child: const Text('Tạo câu hỏi học sinh'),
                ),
              ],
            ),
            StreamBuilder(
              stream: APIs.getDesCriptQues(),
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
                    list = data
                            ?.map((e) => CreateDescriptMode.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (list.isNotEmpty) {
                      // ignore: unnecessary_null_comparison
                      return list == null
                          ? const Loader()
                          : list.isEmpty
                              ? const Center(
                                  child: Text('No messages available'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(6),
                                  itemBuilder: (context, index) {
                                    return DesGVQesCard(model: list[index]);
                                  },
                                );
                    } else {
                      return const Center(
                          child: Text(
                        '',
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
