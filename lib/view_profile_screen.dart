
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thutext/models/user_model.dart';
import '../helpers/my_date_uti.dart';
import '../main.dart';


class ViewProfileScreen extends StatefulWidget {
  final UserModel user;
  const ViewProfileScreen({super.key,required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar:AppBar(
          title: Text(widget.user.name),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Joined On: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),

            //Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),style: TextStyle(color: Colors.black54,fontSize: 16),),
          ],
        ),

        // stream tự động  cập nhật giao diện khi có sự thay đôi
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Form(

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: CachedNetworkImage(
                            width: 2,
                            height: 2,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                          ),
                        ),

                      ],
                    ),
                    // use profile picture
                    SizedBox(width: 3,height: 3,),
                    SizedBox(height: 3,),
                    Text(widget.user.email,style: TextStyle(color: Colors.black,fontSize: 16),),
                    SizedBox(height: 2,),

                    // user about
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('About: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),
                        Text(widget.user.about,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 16),),

                      ],
                    )



                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
