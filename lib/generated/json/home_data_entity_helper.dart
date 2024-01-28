import 'package:tob/entity/home_data_entity.dart';

homeDataEntityFromJson(HomeDataEntity data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['extra'] != null) {
		data.extra = json['extra'].toString();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => v).toList().cast<dynamic>();
	}
	return data;
}

Map<String, dynamic> homeDataEntityToJson(HomeDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['extra'] = entity.extra;
	data['data'] = entity.data;
	return data;
}