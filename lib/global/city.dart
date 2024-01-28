import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:tob/entity/city/city_chose_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';

class City {
  static List<CityChoseEntity> _cityChoseEntity;

  ///设置城市选择数据
  static void setCity(List<CityChoseEntity> cityChoseEntity) {
    _cityChoseEntity = cityChoseEntity;
    String _cityChoseEntityStr;
    if (cityChoseEntity != null) {
      _cityChoseEntityStr = jsonEncode(_cityChoseEntity);
    }
    SpUtil.putString("city_chose", _cityChoseEntityStr);
  }
  ///获取城市选择数据
  static List<CityChoseEntity> getCity() {
    if (_cityChoseEntity == null) {
      String _cityChoseEntityStr = SpUtil.getString("city_chose");
      if (_cityChoseEntityStr != null && _cityChoseEntityStr.isNotEmpty) {
        var _map = jsonDecode(_cityChoseEntityStr);
        _cityChoseEntity = JsonConvert.fromJsonAsT<List<CityChoseEntity>>(_map);
      }
    }
    return _cityChoseEntity;
  }
}
