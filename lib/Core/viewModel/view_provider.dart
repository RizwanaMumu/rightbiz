import 'package:flutter/cupertino.dart';

class ViewProvider extends ChangeNotifier{
  int indexSelected = 0;

  changeDrawerTabIndx(int indx){
    indexSelected == indx;
    notifyListeners();
  }
}