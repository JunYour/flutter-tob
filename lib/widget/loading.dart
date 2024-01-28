import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static void show({String status}) {
    if(status != null){
      EasyLoading.show(status: status,maskType: EasyLoadingMaskType.clear);
    }else{
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
    }
  }

  static void toast({@required String msg,EasyLoadingMaskType maskType}){
    Future.delayed(Duration(milliseconds: 0)).then((value){
      EasyLoading.showToast(msg,toastPosition: EasyLoadingToastPosition.center,maskType:maskType);
    });
  }

  static void dismiss(){
    EasyLoading.dismiss();
  }
}
