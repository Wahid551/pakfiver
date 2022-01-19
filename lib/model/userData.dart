class UserModel {
  String firstName;
  String lastName;
  String userEmail;
  String userImage;
  String city;
  String DOB;
  String gender;
  String phone;
  String uid;


  UserModel({
    required this.userEmail,
    required this.userImage,
    required this.firstName,
    required this.city,
    required this.DOB,
    required this.gender,required this.lastName,
    required this.phone,
    required this.uid,

  });
}