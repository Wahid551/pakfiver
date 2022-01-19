import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pakfiver/model/buyersRequest.dart';
import 'package:pakfiver/pages/inbox.dart';
import 'package:pakfiver/provider/chatRoomProvidr.dart';
import 'package:pakfiver/provider/notification_provider.dart';
import 'package:pakfiver/provider/requesrProvider.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late Notification_provider _notiProvider;
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
    if (userName != myName){
      List<String> users = [myName, userName];
      String chatRoomId = getChatRoomId(myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
        "userImage":userImage,
      };

      chat.addChatRoom(chatRoomId, chatRoomMap).then((value) {
        _notiProvider.addData(userUid,myName,"respond at your post request",'');
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
      print('You can not send offer');
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
    _notiProvider=Provider.of(context);
    data=Provider.of(context);
    RequestProvider requestProvider = Provider.of(context);
    requestProvider.getData();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Buyer's Requests",
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          requestProvider.getRequestDataList.isEmpty
              ? Center(
                  child: Text('No Data'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestProvider.getRequestDataList.length,
                  itemBuilder: (context, index) {
                    BuyersRequest _buyersData =
                        requestProvider.getRequestDataList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 5.0, right: 5.0),
                      child: Card(
                        elevation: 8.0,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              _buyersData.img=='no image'?'https://www.freeiconspng.com/uploads/no-image-icon-4.png':_buyersData.img,
                                            ),
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Text(
                                            _buyersData.name,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:
                                              Text(_buyersData.price + '/Rs'),
                                          trailing: SizedBox(
                                            width: 110.0,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Icon(
                                                  Icons.add_location,
                                                  color: Colors.blue,
                                                )),
                                                Expanded(
                                                    child: Text('Pakistan')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _buyersData.desc,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        createChatRoomAndStartConversation(_buyersData.name, data.currentUserData.firstName, _buyersData.img, _buyersData.uid, data.currentUserData.uid);
                                      },
                                      shape: StadiumBorder(),
                                      splashColor: Colors.black,
                                      autofocus: true,
                                      color: Colors.green.shade400,
                                      child: Text('Send Offer'),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  },
                )
        ]),
      ),
    );
  }
}
