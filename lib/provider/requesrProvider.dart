

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pakfiver/model/buyersRequest.dart';

class RequestProvider extends ChangeNotifier{

  Future<void> addData(GigData) async {
    FirebaseFirestore.instance
        .collection("MyRequests").doc(FirebaseAuth.instance.currentUser.uid).collection("MyRequests")
        .add(GigData).then((value) {

      FirebaseFirestore.instance
          .collection("AllRequests")
          .add(GigData).catchError((e){
        print(e);
      });
    })
        .catchError((e) {
      print(e);
    });
    notifyListeners();
  }

  List<BuyersRequest>  _buyers=[];
  void getData()async{
    BuyersRequest buyerModel;
    List<BuyersRequest> _newList=[];
    QuerySnapshot value=   await FirebaseFirestore.instance.collection('AllRequests').get();
    // print(value.docs.length);
    value.docs.forEach((element) {
      buyerModel=BuyersRequest(uid: element.get('userUid'), desc: element.get('desc'), title: element.get('title'), price: element.get('price'),img: element.get('userImage'),name: element.get('userName'));
      // print('Title is: '+buyerModel.title);
      _newList.add(buyerModel);

    });
    _buyers=_newList;

    // print(_gigs.length);
    notifyListeners();
  }
  List<BuyersRequest> get getRequestDataList{
    return _buyers;
  }
   List<BuyersRequest> my_requests=[];
  void getMyRequestData()async{
    BuyersRequest buyersRequest;
    List<BuyersRequest> _newList=[];
    QuerySnapshot value=   await FirebaseFirestore.instance.collection('MyRequests').doc(FirebaseAuth.instance.currentUser.uid).collection("MyRequests").get();
    value.docs.forEach((element) {
      buyersRequest=BuyersRequest(uid: element.get("userUid"),name: element.get("userName"),desc: element.get("desc"),img: element.get("userImage"),title: element.get("title"),price: element.get("price"),);
      _newList.add(buyersRequest);
      notifyListeners();

    });
    my_requests=_newList;
    notifyListeners();

  }
  List<BuyersRequest> get getMyPostDataList {
    return my_requests;
  }
  Future<void> UpdateRequest(GigData,uid) async {

    FirebaseFirestore.instance
        .collection("MyRequests")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("MyRequests")
        .where("userUid", isEqualTo: uid)
        .get()
        .then((res) {
      print(res.docs.length);
      FirebaseFirestore.instance
          .collection("MyRequests")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("MyRequests")
          .doc(res.docs[0].id)
          .update(GigData);
      notifyListeners();

    });

    FirebaseFirestore.instance
        .collection("AllRequests").where("userUid",isEqualTo: uid).get().then((res){
      FirebaseFirestore.instance.collection("AllRequests").doc(res.docs[0].id).update(GigData);
      notifyListeners();
    });



    notifyListeners();

  }
  Future<void >deleteRequest(uid)async{
    FirebaseFirestore.instance
        .collection("MyRequests")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("MyRequests")
        .where("userUid", isEqualTo: uid)
        .get()
        .then((res) {
      print(res.docs.length);
      FirebaseFirestore.instance
          .collection("MyRequests")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("MyRequests")
          .doc(res.docs[0].id).delete();
      notifyListeners();

    });

    FirebaseFirestore.instance
        .collection("AllRequests").where("userUid",isEqualTo: uid).get().then((res){
      FirebaseFirestore.instance.collection("AllRequests").doc(res.docs[0].id).delete();
      notifyListeners();
    });
  }
}