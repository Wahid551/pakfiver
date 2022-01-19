

import 'package:flutter/foundation.dart';

class ExchangeProvider with ChangeNotifier{

  bool gigHomePage=true;

  void exchangePage(){
    gigHomePage==false;
    notifyListeners();
  }
}