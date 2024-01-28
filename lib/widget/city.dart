import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:tob/entity/city/city_chose_entity.dart';
import 'package:tob/global/city.dart';
import 'package:tob/network/http.dart';
import 'package:tob/widget/loading.dart';

///城市选择器
cityChose({@required BuildContext context, @required Function func}) async {
  List<CityChoseEntity> cityChoseEntity = City.getCity();
  if (cityChoseEntity == null) {
    Loading.show();
    cityChoseEntity = await Http.getInstance()
        .getChoseCity()
        .whenComplete(() => Loading.dismiss());
    City.setCity(cityChoseEntity);
  }

  Map map = {};
  cityChoseEntity.asMap().forEach((key, value) {
    Map cityMap = {};
    value.child.asMap().forEach((keyCity, valueCity) {
      Map districtMap = {};
      valueCity.child.asMap().forEach((keyDistrict, valueDistrict) {
        districtMap.addAll({valueDistrict.name: ''});
      });
      cityMap.addAll({
        valueCity.name: districtMap,
      });
    });
    Map other = {value.name: cityMap};
    map.addAll(other);
  });
  Pickers.showMultiLinkPicker(
    context,
    data: map,
    columeNum: 3,
    suffix: ['', '', ''],
    onConfirm: (List p, List i) {
      if (func != null) {
        func(p.join('/'));
      }
    },
  );
}
