import 'package:tob/entity/base_data_entity.dart';

baseDataEntityFromJson(BaseDataEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['group'] != null) {
		data.group = json['group'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['tip'] != null) {
		data.tip = json['tip'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['value'] != null) {
		data.value = json['value'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['rule'] != null) {
		data.rule = json['rule'].toString();
	}
	if (json['extend'] != null) {
		data.extend = json['extend'].toString();
	}
	if (json['setting'] != null) {
		data.setting = json['setting'].toString();
	}
	return data;
}

Map<String, dynamic> baseDataEntityToJson(BaseDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['group'] = entity.group;
	data['title'] = entity.title;
	data['tip'] = entity.tip;
	data['type'] = entity.type;
	data['value'] = entity.value;
	data['content'] = entity.content;
	data['rule'] = entity.rule;
	data['extend'] = entity.extend;
	data['setting'] = entity.setting;
	return data;
}