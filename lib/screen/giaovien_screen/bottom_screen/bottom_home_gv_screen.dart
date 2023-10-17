
import 'package:flutter/material.dart';
import 'package:thutext/api/apis.dart';
import 'package:thutext/screen/giaovien_screen/create_question/create_question_screen.dart';
import '../../../models/giao_vien/create_description_model.dart';
import '../../../widgets/descript_giaoviden_ques.dart';


class BottomHomeGVcreen extends StatefulWidget {
  const BottomHomeGVcreen({Key? key});

  @override
  _BottomHomeGVScreenState createState() => _BottomHomeGVScreenState();
}

class _BottomHomeGVScreenState extends State<BottomHomeGVcreen> {
  List<CreateDescriptMode> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Questions'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: ()  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuestionGVScreen()),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateQuestionGVScreen()),
                    );
                  },
                  child: Text('Tạo câu hỏi học sinh'),
                ),
              ],
            ),
            StreamBuilder(
              stream: APIs.getDesCriptQues(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final data = snapshot.data?.docs;
                  list = data?.map((e) => CreateDescriptMode.fromJson(e.data())).toList() ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                      physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(6),
                    itemBuilder: (context, index) {
                      return DesGVQesCard(model: list[index]);
                    },
                  );
                } else {
                  return Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
