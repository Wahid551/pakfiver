import 'package:flutter/material.dart';
import 'package:pakfiver/model/buyersRequest.dart';

import 'package:pakfiver/model/gigModel.dart';
import 'package:pakfiver/pages/notification.dart';
import 'package:pakfiver/pages/drawer.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:pakfiver/provider/requesrProvider.dart';

import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

import 'Gig_DetailPage/gig_detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userData _userData=Provider.of<userData>(context);
    GigProvider _gigProvider=Provider.of<GigProvider>(context);
     RequestProvider _buyer=Provider.of(context);
     _buyer.getMyRequestData();
   _gigProvider.getMyGigData();
    _userData.getUserData();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Home",
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(userProvider: _userData,),
      body: SafeArea(
        child:Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'All Gigs',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20,
          ),
          _gigProvider.getGigsDataList.isEmpty?Center(
            child: Text('No Data'),
          ):
          ListView.builder(
            shrinkWrap: true,
            itemCount: _gigProvider.getGigsDataList.length,
            itemBuilder: (context, index){
              GigModel _gigData=_gigProvider.getGigsDataList[index];
               // var formattedTime = DateFormat('dd MMM - HH:mm')
               //   .format(_gigData.date);
              // print(_gigData);
              return  Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(gigData: _gigData,index: index,myself: false,)));
                  },
                  child: Card(
                    child: Container(
                      height: 120,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Hero(
                              tag: 'location_img-$index',
                              child: Container(
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      _gigData.ImgUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 120.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.star,
                                                  size: 12.0,
                                                  color: Colors.amber,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(left: 4.0),
                                                  child: Text(
                                                    _gigData.title,
                                                    // gigs[index]['ratings'].toString(),
                                                    style: TextStyle(
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width *
                                                  0.35,
                                              child: Text(
                                               _gigData.desc,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "From ",
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                        Text(
                                          _gigData.price,
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },

          ),

          // ListView.separated(
          //   shrinkWrap: true,
          //   itemCount: 15,
          //   itemBuilder: (context, index) {
          //     // final post = data[index];
          //     return  InkWell(
          //       // onTap: onClick,
          //       child: Container(
          //         child: Row(
          //           children: [
          //             Container(
          //               width: 120,
          //               height: 75,
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.circular(8),
          //                 child: Image.asset(
          //                   'assets/images/logo.png',
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(
          //               width: 20,
          //             ),
          //             Expanded(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     'FLutter developer',
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       color: Colors.black,
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //                   Text(
          //                     'Wahid',
          //                     style: TextStyle(
          //                       fontSize: 10,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          //   separatorBuilder: (context, index) => Divider(),
          // ),
  ],
          ),
        ),

      ),

    );
  }
}
