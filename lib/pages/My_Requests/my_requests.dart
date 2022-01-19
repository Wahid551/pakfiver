import 'package:flutter/material.dart';
import 'package:pakfiver/model/buyersRequest.dart';
import 'package:pakfiver/pages/My_Requests/my_request_edit.dart';
import 'package:pakfiver/provider/requesrProvider.dart';
import 'package:provider/provider.dart';


class My_request extends StatefulWidget {
  const My_request({Key? key}) : super(key: key);

  @override
  _My_requestState createState() => _My_requestState();
}

class _My_requestState extends State<My_request> {

   bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    RequestProvider requestProvider = Provider.of<RequestProvider>(context);
   // var data= requestProvider.getMyPostDataList;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "My Requests",
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          requestProvider.getMyPostDataList.isEmpty
              ? Center(
            child: Text('No Data'),
          )
              : ListView.builder(
            shrinkWrap: true,
            itemCount: requestProvider.getMyPostDataList.length,
            itemBuilder: (context, index) {
              BuyersRequest _buyersData =
              requestProvider.getMyPostDataList[index];
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
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Edit_Requests(buyerData: _buyersData)));
                                      // createChatRoomAndStartConversation(_buyersData.name, data.currentUserData.firstName, _buyersData.img, _buyersData.uid, data.currentUserData.uid);
                                    },
                                    shape: StadiumBorder(),
                                    splashColor: Colors.black,
                                    autofocus: true,
                                    color: Colors.green.shade400,
                                    child: Text('Edit'),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                 _isLoading==true?Expanded(child: CircularProgressIndicator()): Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading=true;
                                      });
                                      requestProvider.deleteRequest(_buyersData.uid).then((value){
                                        setState(() {
                                          _isLoading=false;
                                        });
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>My_request()));
                                      });
                                      // createChatRoomAndStartConversation(_buyersData.name, data.currentUserData.firstName, _buyersData.img, _buyersData.uid, data.currentUserData.uid);
                                    },
                                    shape: StadiumBorder(),
                                    splashColor: Colors.black,
                                    autofocus: true,
                                    color: Colors.red,
                                    child: Text('Delete'),
                                  ),
                                )
                              ],
                            ),
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
