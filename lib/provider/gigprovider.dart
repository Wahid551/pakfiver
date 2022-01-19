

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pakfiver/model/gigModel.dart';
import 'package:pakfiver/provider/userDataProvider.dart';
import 'package:provider/provider.dart';

class GigProvider extends ChangeNotifier{

  Future<void> addData(GigData) async {
    FirebaseFirestore.instance
        .collection("MyGigs").doc(FirebaseAuth.instance.currentUser.uid).collection("MyGigs")
        .add(GigData).then((value) {

      FirebaseFirestore.instance
          .collection("AllGigs")
          .add(GigData).catchError((e){
            print(e);
      });
    })
        .catchError((e) {
      print(e);
    });
    notifyListeners();
  }
 List<GigModel>  _gigs=[];
 List<GigModel> my_gigs=[];
  void getData()async{
    GigModel gigModel;
    List<GigModel> _newList=[];
   QuerySnapshot value=   await FirebaseFirestore.instance.collection('AllGigs').get();
    value.docs.forEach((element) { 
      gigModel=GigModel(uid: element.get("userUid"), skill:element.get('skill'),userName:element.get('userName'),userImage:element.get('userImage'),price: element.get('price'), desc: element.get('desc'), ImgUrl: element.get('imgUrl'),title: element.get('title'),date: element.get('DateTime'));
      _newList.add(gigModel);

    });
    _gigs=_newList;

    // print(_gigs.length);
    notifyListeners();

  }
  List<GigModel> get getGigsDataList {
    return _gigs;
  }

  void getMyGigData()async{
    GigModel gigModel;
    List<GigModel> _newList=[];
    QuerySnapshot value=   await FirebaseFirestore.instance.collection('MyGigs').doc(FirebaseAuth.instance.currentUser.uid).collection("MyGigs").get();
    value.docs.forEach((element) {
      gigModel=GigModel(uid: element.get("userUid"), skill:element.get('skill'),userName:element.get('userName'),userImage:element.get('userImage'),price: element.get('price'), desc: element.get('desc'), ImgUrl: element.get('imgUrl'),title: element.get('title'),date: element.get('DateTime'));
      _newList.add(gigModel);
      notifyListeners();

    });
    my_gigs=_newList;
    notifyListeners();

  }
  List<GigModel> get getMyGigsDataList {
    return my_gigs;
  }

  Future<void> UpdateGig(GigData,uid) async {

    FirebaseFirestore.instance
        .collection("MyGigs")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("MyGigs")
        .where("userUid", isEqualTo: uid)
        .get()
        .then((res) {
        print(res.docs.length);
        FirebaseFirestore.instance
            .collection("MyGigs")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("MyGigs")
            .doc(res.docs[0].id)
            .update(GigData);
        notifyListeners();

    });

    FirebaseFirestore.instance
        .collection("AllGigs").where("userUid",isEqualTo: uid).get().then((res){
          FirebaseFirestore.instance.collection("AllGigs").doc(res.docs[0].id).update(GigData);
          notifyListeners();
    });



    notifyListeners();

  }

  Future<void >deleteGig(uid)async{
    FirebaseFirestore.instance
        .collection("MyGigs")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("MyGigs")
        .where("userUid", isEqualTo: uid)
        .get()
        .then((res) {
      print(res.docs.length);
      FirebaseFirestore.instance
          .collection("MyGigs")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("MyGigs")
          .doc(res.docs[0].id).delete();
      notifyListeners();

    });

    FirebaseFirestore.instance
        .collection("AllGigs").where("userUid",isEqualTo: uid).get().then((res){
      FirebaseFirestore.instance.collection("AllGigs").doc(res.docs[0].id).delete();
      notifyListeners();
    });
  }
}