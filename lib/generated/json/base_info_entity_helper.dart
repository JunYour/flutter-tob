import 'package:tob/entity/base_info_entity.dart';

baseInfoEntityFromJson(BaseInfoEntity data, Map<String, dynamic> json) {
	if (json['app_name'] != null) {
		data.appName = json['app_name'].toString();
	}
	if (json['back_phone'] != null) {
		data.backPhone = json['back_phone'].toString();
	}
	if (json['show_share'] != null) {
		data.showShare = json['show_share'];
	}
	if (json['buycar_intro'] != null) {
		data.buycarIntro = json['buycar_intro'].toString();
	}
	if (json['mail'] != null) {
		data.mail = BaseInfoMail().fromJson(json['mail']);
	}
	return data;
}

Map<String, dynamic> baseInfoEntityToJson(BaseInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['app_name'] = entity.appName;
	data['back_phone'] = entity.backPhone;
	data['show_share'] = entity.showShare;
	data['buycar_intro'] = entity.buycarIntro;
	data['mail'] = entity.mail?.toJson();
	return data;
}

baseInfoMailFromJson(BaseInfoMail data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	return data;
}

Map<String, dynamic> baseInfoMailToJson(BaseInfoMail entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['phone'] = entity.phone;
	data['address'] = entity.address;
	return data;
}