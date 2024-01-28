import 'package:sp_util/sp_util.dart';
import 'dart:convert' as convert;

import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';

class UserInfo{
  static UserInfoEntity _userInfoEntity;

  static void setUserInfo(UserInfoEntity userInfoEntity) {
    _userInfoEntity = userInfoEntity;
    String _userInfoEntityStr;
    if (userInfoEntity != null) {
      _userInfoEntityStr = convert.jsonEncode(userInfoEntity.toJson());
    }
    SpUtil.putString("user_info", _userInfoEntityStr);
  }

  static UserInfoEntity getUserInfo() {
    if (_userInfoEntity == null) {
      String _userInfoJsonStr = SpUtil.getString("user_info");
      if (_userInfoJsonStr != null && _userInfoJsonStr.isNotEmpty) {
        Map<String, dynamic> _map = convert.jsonDecode(_userInfoJsonStr);
        _userInfoEntity = JsonConvert.fromJsonAsT<UserInfoEntity>(_map);
      }
    }
    return _userInfoEntity;
  }

  static int getUserInfoId(){
    if (_userInfoEntity == null) {
      String _userInfoJsonStr = SpUtil.getString("user_info");
      if (_userInfoJsonStr != null && _userInfoJsonStr.isNotEmpty) {
        Map<String, dynamic> _map = convert.jsonDecode(_userInfoJsonStr);
        _userInfoEntity = JsonConvert.fromJsonAsT<UserInfoEntity>(_map);
      }
    }
    return _userInfoEntity?.id??null;
  }

  static bool getUserVip(){
    if (_userInfoEntity == null) {
      String _userInfoJsonStr = SpUtil.getString("user_info");
      if (_userInfoJsonStr != null && _userInfoJsonStr.isNotEmpty) {
        Map<String, dynamic> _map = convert.jsonDecode(_userInfoJsonStr);
        _userInfoEntity = JsonConvert.fromJsonAsT<UserInfoEntity>(_map);
      }
    }
    int vip = _userInfoEntity?.isVip??null;
    if(vip!=null && vip==2){
      return true;
    }
    return false;
  }

  static void clearUserInfo(){
    SpUtil.remove('user_info');
  }
}