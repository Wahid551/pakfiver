
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pakfiver/model/userData.dart';

class userData extends ChangeNotifier{

   late UserModel currentData;

  void getUserData() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection("UserRecord")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        uid: value.get("userUid"),
        userEmail: value.get("Email"),
        userImage: value.get("userImage"),
        firstName: value.get("FirstName"),
        lastName: value.get('LastName'),
        city: value.get('City'),
        DOB: value.get('DoB'),
        gender: value.get('Gender'),
        phone: value.get('phone'),
      );
      currentData = userModel;
      notifyListeners();
    }
  }

  UserModel get currentUserData {
    return currentData;
  }

  void UpdateData(String ImagePath,String phone,String fname,String city)async{
    await FirebaseFirestore.instance.collection('UserRecord').doc(FirebaseAuth.instance.currentUser.uid).update({
      "Email":currentData.userEmail,
      "userImage":ImagePath,
      "FirstName":fname,
      "LastName":currentUserData.lastName,
      "City":city,
      "DoB":currentUserData.DOB,
      "Gender":currentUserData.gender,
      "phone":phone,
    });
    notifyListeners();
  }
}