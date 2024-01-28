import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:tob/entity/bank_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';

class Order {
  static BankEntity _bankEntity;

  //设置银行账户
  static void setBank(BankEntity bank) {
    _bankEntity = bank;
    String _bankStr;
    if (bank != null) {
      _bankStr = jsonEncode(bank);
    }
    SpUtil.putString("bank", _bankStr);
  }
  //获取银行账户
  static BankEntity getBank() {
    if (_bankEntity == null) {
      String _bankStr = SpUtil.getString("bank");
      if (_bankStr != null && _bankStr.isNotEmpty) {
        Map<String, dynamic> _map = jsonDecode(_bankStr);
        _bankEntity = JsonConvert.fromJsonAsT<BankEntity>(_map);
      }
    }
    return _bankEntity;
  }
}
