import 'package:flutter/material.dart';

import 'package:pakfiver/model/gigModel.dart';

import 'package:pakfiver/pages/notification.dart';
import 'package:pakfiver/pages/search_detail.dart';
import 'package:pakfiver/provider/gigprovider.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isSeller = true;
  late GigProvider _gigProvider;
  String query = '';
  searchGig(query){
    List<GigModel> Gigs=_gigProvider.getGigsDataList.where((element) {
      return element.title.toLowerCase().contains(query);
    }).toList();
    return Gigs;
  }

  @override
  Widget build(BuildContext context) {
    _gigProvider=Provider.of(context);
    List<GigModel> _gigsData=searchGig(query);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Browse",
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
          )
        ],
      ),
      body:  ListView(
        children: [
          SizedBox(height: 10.0,),
          Container(
            height: 52,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffc2c2c2),
                filled: true,
                hintText: "Search for specific gig in the app",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Column(
            children: _gigsData.map((e) {
              return  Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                child: GestureDetector(
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Details(username: e.userName,title: e.title,desc: e.desc,imgUrl: e.ImgUrl,index: e.date,price: e.price,skills: e.skill,userImage: e.userImage,userUid: e.uid,)));
                  },
                  child: Card(
                    child: Container(
                      height: 120,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Hero(
                              tag: 'location_img-'+e.date,
                              child: Container(
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      e.ImgUrl,
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
                                                    e.title,
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
                                                e.desc,
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
                                          e.price,
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
            }).toList(),
          ),
        ],
      )
      // drawer: MyDrawer(),
    );
  }
}
