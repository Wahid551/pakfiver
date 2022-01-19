

import 'package:flutter/foundation.dart';

class UserMode extends ChangeNotifier{
     bool status=true;
     void Status(bool mode){
           status=mode;
           notifyListeners();
     }
     bool gigHomePage=true;

     void exchangePage(bool value){
       gigHomePage==value;
       notifyListeners();
     }

}