import 'package:flutter/material.dart';
import 'package:pakfiver/pages/conversation.dart';
import 'package:pakfiver/provider/chatRoomProvidr.dart';

import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

class MessageInboxPage extends StatefulWidget {
  @override
  _MessageInboxPageState createState() => _MessageInboxPageState();
}

class _MessageInboxPageState extends State<MessageInboxPage> {
   chatRoomProvider chatroomProvider=chatRoomProvider();
  late userData userdata;
  Stream? chatRooms;
  @override
  void initState() {
    userdata=Provider.of<userData>(context,listen: false);
    getUserInfo();
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async {
    chatroomProvider.getUserChats(userdata.currentUserData.firstName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${userdata.currentUserData.firstName}");
      });
    });
  }

  Future<void> _refreshMessages() async {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Inbox",
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black87,
        onRefresh: _refreshMessages,
        child: StreamBuilder<dynamic>(
          stream: chatRooms,
          builder: (context,snapshot){
            return snapshot.hasData?
            ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Conversation(chatRoomId: snapshot.data.docs[index].data()["chatRoomId"])));
                  },
                  child: Column(

                    children: [
                      SizedBox(height: 10.0,),
                      ListTile(
                        shape: StadiumBorder(),
                        leading: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(snapshot.data!.docs[index]
                                  .data()['userImage']=='no image'?'https://www.freeiconspng.com/uploads/no-image-icon-4.png':snapshot.data!.docs[index]
                                  .data()['userImage']),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(snapshot.data!.docs[index]
                                .data()['chatRoomId']
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(userdata.currentUserData.firstName, ""),),
                            SizedBox(
                              width: 5.0,
                            ),
                          ],
                        ),

                      ),
                      SizedBox(height: 10.0,),
                      Divider(height: 5.0,thickness: 2.0,),
                    ],

                  ),
                );
              },
            )
                :Container();
          },
        ),
      ),
    );
  }
}

class MessageFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select label"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "FILTERS",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "All",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Unread",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Starred",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Archived",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Spam",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sent",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Custom Offers",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "LABELS",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Follow-up",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Nudge",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}