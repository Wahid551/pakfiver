import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakfiver/model/gigModel.dart';
import 'package:pakfiver/pages/Edit_Delete/Edit_Gig.dart';
import 'package:pakfiver/pages/My_Gigs.dart';
import 'package:pakfiver/pages/inbox.dart';
import 'package:pakfiver/provider/chatRoomProvidr.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/notification_provider.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  GigModel gigData;
  int index;
  bool myself;

  Details({required this.gigData, required this.index, required this.myself});

  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late GigProvider _gigProvider;
  late Notification_provider _notifyProvider;
  chatRoomProvider chat = chatRoomProvider();
  late userData data;
  bool _isLoading=false;

  createChatRoomAndStartConversation(String userName, String myName,
      String userImage, String userUid, String myUid) async {
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
    if (userName != myName) {
      List<String> users = [myName, userName];
      String chatRoomId = getChatRoomId(myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        "userImage": userImage,
      };

      chat.addChatRoom(chatRoomId, chatRoomMap).then((value) {
        print(widget.gigData.title);
        _notifyProvider.addData(userUid, myName, "respond at your gig",widget.gigData.title);
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MessageInboxPage()));
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
    _notifyProvider = Provider.of(context);
    data = Provider.of(context);
    int num = widget.index;
    _gigProvider=Provider.of(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _isLoading==true?Center(child: Container(child: CircularProgressIndicator(),),):  ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                      //Hero Animation
                      child: Hero(
                    tag: 'location_img-$num',
                    child: Image.network(
                      widget.gigData.ImgUrl,
                      height: 360,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  )),
                  SizedBox(height: 30),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.gigData.userImage,
                      ),
                      radius: 30,
                      backgroundColor: Colors.white,
                    ),
                    title: Text(widget.gigData.userName,
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                    trailing: SizedBox(
                      width: 90.0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_location,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Pakistan'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 5.0,
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text(widget.gigData.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue)),
                    trailing: Text(widget.gigData.price + '/rs',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      widget.gigData.desc,
                      maxLines: 7,
                      style: TextStyle(color: Colors.grey[600], height: 1.4),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Skills : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(widget.gigData.skill),
                  ),
                  widget.myself != true
                      ? Padding(
                          padding: EdgeInsets.all(18),
                          child: MaterialButton(
                            onPressed: () {
                              createChatRoomAndStartConversation(
                                  widget.gigData.userName,
                                  data.currentUserData.firstName,
                                  widget.gigData.userImage,
                                  widget.gigData.uid,
                                  data.currentUserData.uid);
                            },
                            color: Colors.green,
                            shape: StadiumBorder(),
                            child: Text('Chat with Developer'),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditGig(gigData: widget.gigData,)));
                                },
                                color: Colors.green,
                                shape: StadiumBorder(),
                                child: Text('Edit'),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                      _gigProvider.deleteGig(widget.gigData.uid).then((value){
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>My_Gigs()));
                                      });
                                },
                                color: Colors.red,
                                shape: StadiumBorder(),
                                child: Text('Delete'),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ));
  }
}
