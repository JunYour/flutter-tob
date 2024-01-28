import 'package:tob/entity/base_entity.dart';

baseEntityFromJson(BaseEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['data'] != null) {
		data.data = json['data'];
	}
	return data;
}

Map<String, dynamic> baseEntityToJson(BaseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['msg'] = entity.msg;
	data['data'] = entity.data;
	return data;
}