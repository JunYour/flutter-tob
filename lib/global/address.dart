import 'package:sp_util/sp_util.dart';
import 'package:tob/entity/address/address_list_entity.dart';
import 'dart:convert' as convert;

import 'package:tob/generated/json/base/json_convert_content.dart';

class Address{
  static AddressListList _addressListList;
  static String name = "address";
  static void setAddress(AddressListList addressListList) {
    _addressListList = addressListList;
    String _addressListListStr;
    if (addressListList != null) {
      _addressListListStr = convert.jsonEncode(addressListList.toJson());
    }
    SpUtil.putString(name, _addressListListStr);
  }

  static AddressListList getAddress() {
    if (_addressListList == null) {
      String __addressListListStr = SpUtil.getString(name);
      if (__addressListListStr != null && __addressListListStr.isNotEmpty) {
        Map<String, dynamic> _map = convert.jsonDecode(__addressListListStr);
        _addressListList = JsonConvert.fromJsonAsT<AddressListList>(_map);
      }
    }
    return _addressListList;
  }
  static void clearAddress(){
    SpUtil.remove(name);
  }
}