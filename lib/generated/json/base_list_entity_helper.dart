import 'package:tob/entity/base_list_entity.dart';

baseListEntityFromJson(BaseListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => v).toList().cast<dynamic>();
	}
	return data;
}

Map<String, dynamic> baseListEntityToJson(BaseListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['msg'] = entity.msg;
	data['data'] = entity.data;
	return data;
}