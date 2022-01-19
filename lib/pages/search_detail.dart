

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakfiver/model/gigModel.dart';
import 'package:pakfiver/pages/inbox.dart';
import 'package:pakfiver/provider/chatRoomProvidr.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/notification_provider.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  late String username;
  late String title;
  late String desc;
  late String imgUrl;
  late String index;
  late String price;
  late String skills;
  late String userImage;
  late String userUid;
  Details({required this.userImage,required this.price,required this.desc,required this.title,required this.skills,required this.imgUrl,required this.userUid,required this.index,required this.username});

  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Notification_provider _notifyProvider;
  chatRoomProvider chat=chatRoomProvider();
  late userData data;
  createChatRoomAndStartConversation(String userName,String myName,String userImage,String userUid,String myUid) async {
    print('userName $myName');
    print(userName);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Row(
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 25.0,
                ),
                new Text("Loading, Please wait"),
              ],
            ),
          ),
        );
      },
    );
    if (userUid != myUid){
      List<String> users = [myName, userName];
      String chatRoomId = getChatRoomId(myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        "userImage":userImage,
      };

      chat.addChatRoom(chatRoomId, chatRoomMap).then((value){
        _notifyProvider.addData(userUid, myName, "respond at your gig",widget.title);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MessageInboxPage()));
      });
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "You can not send offer to yourself.",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      print('You can not send message to yourself.');
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  @override
  Widget build(BuildContext context) {
    _notifyProvider=Provider.of(context);
    data=Provider.of(context);
    String id=widget.index;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    //Hero Animation
                      child: Hero(
                        tag: 'location_img-'+id,
                        child: Image.network(
                          widget.imgUrl,
                          height: 360,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      )),
                  SizedBox(height: 30),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.userImage,
                      ),
                      radius: 30,
                      backgroundColor: Colors.white,
                    ),
                    title: Text(widget.username,
                        style: TextStyle(letterSpacing: 1,fontSize: 22.0,fontWeight: FontWeight.bold)),
                    trailing: SizedBox(
                      width: 90.0,
                      child: Row(
                        children: [
                          Icon(Icons.add_location,color: Colors.blue,),
                          SizedBox(width: 5.0,),
                          Text('Pakistan'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Divider(height: 5.0,thickness: 2.0,),
                  ListTile(
                    title: Text(widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue)),
                    trailing: Text(widget.price+'/rs',
                        style: TextStyle(letterSpacing: 1,fontSize: 22.0,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(widget.desc,
                      maxLines: 7,

                      style: TextStyle(color: Colors.grey[600], height: 1.4),),),
                  ListTile(
                    title: Text('Skills : ',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(widget.skills),

                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child:MaterialButton(
                      onPressed: (){
                        createChatRoomAndStartConversation(widget.username,data.currentUserData.firstName,widget.userImage,widget.userUid,data.currentUserData.uid);
                      },
                      color: Colors.green,
                      shape:StadiumBorder() ,
                      child: Text('Chat with Developer'),
                    ),
                  ),

                ],
              ),
            ),
          ],

        ));
  }
}