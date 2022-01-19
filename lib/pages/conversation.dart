import 'package:flutter/material.dart';
import 'package:pakfiver/provider/chatRoomProvidr.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';



class Conversation extends StatefulWidget {
  String chatRoomId;
  Conversation({required this.chatRoomId});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  chatRoomProvider chatRoom=new chatRoomProvider();
  late userData data;
  Stream? chats;
  TextEditingController messageEditingController = new TextEditingController();
  // List of chat
  Widget chatMessages() {
    return StreamBuilder<dynamic>(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.docs[index].data()["message"],
                sendByMe: data.currentUserData.firstName ==
                    snapshot.data.docs[index].data()["sendBy"],
              );
            })
            : Container();
      },
    );
  }

  //Send Messages
  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": data.currentUserData.firstName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      chatRoom.addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  //---------//
  @override
  void initState() {
    data=Provider.of<userData>(context,listen: false);
    chatRoom.getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
    elevation: 8.0,
    title: Text(
    "Messages",
    ),
        ),
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color.fromARGB(2000, 34, 116, 135),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin:
          sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [Color(0xff808080), const Color(0xff000000)],
          )),
      child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300)),
    ),
    );
  }
}
