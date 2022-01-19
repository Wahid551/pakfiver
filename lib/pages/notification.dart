import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakfiver/model/notification.dart';
import 'package:pakfiver/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Future<void> _refreshNotifications() async {}

  Map<String, IconData> _iconMapping = {
    "complete": FontAwesomeIcons.clipboardCheck,
    "buyerTip": Icons.monetization_on,
    "congrats": FontAwesomeIcons.award,
    "delivery": FontAwesomeIcons.envelopeOpenText
  };
  var _notifications = [
    {
      "icon": "delivery",
      "notification": "brad left a 5 star review. 3d ago",
      "hasRead": false
    },
    {
      "icon": "delivery",
      "notification": "chad left a 5 star review. 3d ago",
      "hasRead": false
    },
    {
      "icon": "complete",
      "notification":
      "fedminz's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
    {
      "icon": "buyerTip",
      "notification": "ninny left you a Tip. 1w ago",
      "hasRead": false
    },
    {
      "icon": "buyerTip",
      "notification": "ninny left you a Tip. 1w ago",
      "hasRead": true
    },
    {
      "icon": "buyerTip",
      "notification": "ninny left you a Tip. 1w ago",
      "hasRead": true
    },
    {
      "icon": "congrats",
      "notification": "Congrats! You're now a Level One Seller!",
      "hasRead": true
    },
    {
      "icon": "complete",
      "notification":
      "fedminz's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
    {
      "icon": "buyerTip",
      "notification": "ninny left you a Tip. 1w ago",
      "hasRead": true
    },
    {
      "icon": "delivery",
      "notification": "brad left a 5 star review. 3d ago",
      "hasRead": true
    },
    {
      "icon": "buyerTip",
      "notification": "adam left you a Tip. 1w ago",
      "hasRead": true
    },
    {
      "icon": "complete",
      "notification":
      "gina's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
    {
      "icon": "complete",
      "notification":
      "lamdz's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
    {
      "icon": "buyerTip",
      "notification": "ninny left you a Tip. 1w ago",
      "hasRead": true
    },
    {
      "icon": "complete",
      "notification":
      "sasha's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
    {
      "icon": "complete",
      "notification":
      "kitty's order was automatically marked as complete. 6d ago",
      "hasRead": true
    },
  ];

  late Notification_provider _notify_provider;
  @override
  Widget build(BuildContext context) {
    _notify_provider=Provider.of(context);
    _notify_provider.getData();
    var data=_notify_provider.getnotifyData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        title: Text("Notifications"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        color: Colors.black87,
        child: data.isEmpty?Center(child: Text("No Data"),): ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, int index) {
              NotifyModel dat=data[index];
              return InkWell(
                onTap: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  color:
                      Colors.white
                    ,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: ListTile(
                      leading: Icon(_iconMapping[_notifications[index]['icon']],
                          size: 25.0,
                          color: _notifications[index]['hasRead'] == true
                              ? Color.fromARGB(2000, 34, 116, 135)
                              : Theme.of(context).accentColor),
                      title: Text(
                        (dat.notification),
                        style: TextStyle(
                          color:

                               Colors.black87,
                          fontSize: 16.0,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(dat.title??'',style: TextStyle(
                        color:

                        Colors.black87,
                        fontSize: 14.0,
                        fontWeight:
                        FontWeight.bold,
                      ),),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}