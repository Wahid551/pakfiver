import 'package:flutter/material.dart';
import 'package:pakfiver/model/buyersRequest.dart';
import 'package:pakfiver/pages/My_Requests/my_requests.dart';
import 'package:pakfiver/provider/requesrProvider.dart';
import 'package:provider/provider.dart';



class Edit_Requests extends StatefulWidget {
  BuyersRequest buyerData;
  Edit_Requests({required this.buyerData});

  @override
  _Edit_RequestsState createState() => _Edit_RequestsState();
}

class _Edit_RequestsState extends State<Edit_Requests> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool _isLoading=false;
  late RequestProvider requestProvider;
   late String title=widget.buyerData.title,price=widget.buyerData.price,desc=widget.buyerData.desc;
  // Update Data
  updatePost() async {

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> gigMap = {
        "userImage":widget.buyerData.img,
        "price": price,
        "title": title,
        "desc": desc,
        'userName': widget.buyerData.name,
        "userUid":widget.buyerData.uid,
        'DateTime': DateTime.now().toIso8601String(),
      };
      requestProvider.UpdateRequest(gigMap,widget.buyerData.uid).then((value) {
        print('Data is uploaded');
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_request()));
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    requestProvider=Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          'Edit Request',
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: FlatButton(
              onPressed: () {
                updatePost();
              },
              child: Icon(
                Icons.file_upload,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Container(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose title of developer you need',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              initialValue: widget.buyerData.title,
                              decoration: InputDecoration(
                                  hintText: "Project Title",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey,
                                          width: 2.0))),
                              onChanged: (val) {
                                setState(() {
                                  title = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty || val.length < 6
                                    ? "Enter Title  6+ characters"
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Enter Price',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),

                            SizedBox(
                              height: 10.0,
                            ),


                            TextFormField(
                              initialValue: widget.buyerData.price,
                              cursorColor:
                              Color.fromARGB(2000, 34, 116, 135),
                              decoration: InputDecoration(
                                  hintText: "Price",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey,
                                          width: 2.0))),
                              onChanged: (val) {
                                setState(() {
                                  price = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty || val.length < 3
                                    ? "Enter 2+ Digits"
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Tell us more about your project',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              initialValue: widget.buyerData.desc,
                              maxLines: 7,
                              maxLengthEnforced: true,
                              decoration: InputDecoration(
                                  hintText: "Description",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey,
                                          width: 2.0))),
                              onChanged: (val) {
                                setState(() {
                                  desc = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty || val.length < 10
                                    ? "Enter Description 10+ characters"
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
