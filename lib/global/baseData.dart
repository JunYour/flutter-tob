import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';

class BaseData {
  ///隐私政策
  static String privacyPolicy = "privacyPolicy";

  ///用户协议
  static String userAgreement = "userAgreement";

  ///帮助中心
  static String helpCenter = "helpCenter";

  ///政策介绍
  static String intro = "intro";

  static void setHelpCenter(BaseDataEntity baseDataEntity) {
    if (baseDataEntity != null) {
      SpUtil.putObject(helpCenter, baseDataEntity);
    } else {
      SpUtil.putObject(helpCenter, null);
    }
  }

  static void setUserAgreement(BaseDataEntity baseDataEntity) {
    if (baseDataEntity != null) {
      SpUtil.putObject(userAgreement, baseDataEntity);
    } else {
      SpUtil.putObject(userAgreement, null);
    }
  }

  static void setPrivacyPolicy(BaseDataEntity baseDataEntity) {
    if (baseDataEntity != null) {
      SpUtil.putObject(privacyPolicy, baseDataEntity);
    } else {
      SpUtil.putObject(privacyPolicy, null);
    }
  }

  static void setIntro(BaseDataEntity baseDataEntity) {
    if (baseDataEntity != null) {
      SpUtil.putObject(intro, baseDataEntity);
    } else {
      SpUtil.putObject(intro, null);
    }
  }

  static BaseDataEntity getPrivacyPolicy() {
    if (SpUtil.getObject(privacyPolicy) != null) {
      String jsonStr = jsonEncode(SpUtil.getObject(privacyPolicy));
      Map<String, dynamic> _map = jsonDecode(jsonStr);
      BaseDataEntity baseDataEntity =
          JsonConvert.fromJsonAsT<BaseDataEntity>(_map);
      return baseDataEntity;
    } else {
      return null;
    }
  }

  static BaseDataEntity getUserAgreement() {
    if (SpUtil.getObject(userAgreement) != null) {
      String jsonStr = jsonEncode(SpUtil.getObject(userAgreement));
      Map<String, dynamic> _map = jsonDecode(jsonStr);
      BaseDataEntity baseDataEntity =
          JsonConvert.fromJsonAsT<BaseDataEntity>(_map);
      return baseDataEntity;
    } else {
      return null;
    }
  }

  static BaseDataEntity getHelpCenter() {
    if (SpUtil.getObject(helpCenter) != null) {
      String jsonStr = jsonEncode(SpUtil.getObject(helpCenter));
      Map<String, dynamic> _map = jsonDecode(jsonStr);
      BaseDataEntity baseDataEntity =
          JsonConvert.fromJsonAsT<BaseDataEntity>(_map);
      return baseDataEntity;
    } else {
      return null;
    }
  }

  static BaseDataEntity getIntro() {
    if (SpUtil.getObject(intro) != null) {
      String jsonStr = jsonEncode(SpUtil.getObject(intro));
      Map<String, dynamic> _map = jsonDecode(jsonStr);
      BaseDataEntity baseDataEntity =
          JsonConvert.fromJsonAsT<BaseDataEntity>(_map);
      return baseDataEntity;
    } else {
      return null;
    }
  }
}
