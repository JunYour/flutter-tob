import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class BaseInfoEntity with JsonConvert<BaseInfoEntity> {
	@JSONField(name: "app_name")
	String appName;
	@JSONField(name: "back_phone")
	String backPhone;
	@JSONField(name: "show_share")
	bool showShare;
	@JSONField(name: "buycar_intro")
	String buycarIntro;
	BaseInfoMail mail;
}

class BaseInfoMail with JsonConvert<BaseInfoMail> {
	String name;
	String phone;
	String address;
}
