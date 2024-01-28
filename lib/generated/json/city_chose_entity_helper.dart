import 'package:tob/entity/city/city_chose_entity.dart';

cityChoseEntityFromJson(CityChoseEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['pid'] != null) {
		data.pid = json['pid'] is String
				? int.tryParse(json['pid'])
				: json['pid'].toInt();
	}
	if (json['shortname'] != null) {
		data.shortname = json['shortname'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['mergename'] != null) {
		data.mergename = json['mergename'].toString();
	}
	if (json['level'] != null) {
		data.level = json['level'] is String
				? int.tryParse(json['level'])
				: json['level'].toInt();
	}
	if (json['pinyin'] != null) {
		data.pinyin = json['pinyin'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'].toString();
	}
	if (json['zip'] != null) {
		data.zip = json['zip'].toString();
	}
	if (json['first'] != null) {
		data.first = json['first'].toString();
	}
	if (json['lng'] != null) {
		data.lng = json['lng'].toString();
	}
	if (json['lat'] != null) {
		data.lat = json['lat'].toString();
	}
	if (json['child'] != null) {
		data.child = (json['child'] as List).map((v) => CityChoseChild().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> cityChoseEntityToJson(CityChoseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['pid'] = entity.pid;
	data['shortname'] = entity.shortname;
	data['name'] = entity.name;
	data['mergename'] = entity.mergename;
	data['level'] = entity.level;
	data['pinyin'] = entity.pinyin;
	data['code'] = entity.code;
	data['zip'] = entity.zip;
	data['first'] = entity.first;
	data['lng'] = entity.lng;
	data['lat'] = entity.lat;
	data['child'] =  entity.child?.map((v) => v.toJson())?.toList();
	return data;
}

cityChoseChildFromJson(CityChoseChild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['pid'] != null) {
		data.pid = json['pid'] is String
				? int.tryParse(json['pid'])
				: json['pid'].toInt();
	}
	if (json['shortname'] != null) {
		data.shortname = json['shortname'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['mergename'] != null) {
		data.mergename = json['mergename'].toString();
	}
	if (json['level'] != null) {
		data.level = json['level'] is String
				? int.tryParse(json['level'])
				: json['level'].toInt();
	}
	if (json['pinyin'] != null) {
		data.pinyin = json['pinyin'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'].toString();
	}
	if (json['zip'] != null) {
		data.zip = json['zip'].toString();
	}
	if (json['first'] != null) {
		data.first = json['first'].toString();
	}
	if (json['lng'] != null) {
		data.lng = json['lng'].toString();
	}
	if (json['lat'] != null) {
		data.lat = json['lat'].toString();
	}
	if (json['child'] != null) {
		data.child = (json['child'] as List).map((v) => CityChoseChildChild().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> cityChoseChildToJson(CityChoseChild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['pid'] = entity.pid;
	data['shortname'] = entity.shortname;
	data['name'] = entity.name;
	data['mergename'] = entity.mergename;
	data['level'] = entity.level;
	data['pinyin'] = entity.pinyin;
	data['code'] = entity.code;
	data['zip'] = entity.zip;
	data['first'] = entity.first;
	data['lng'] = entity.lng;
	data['lat'] = entity.lat;
	data['child'] =  entity.child?.map((v) => v.toJson())?.toList();
	return data;
}

cityChoseChildChildFromJson(CityChoseChildChild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['pid'] != null) {
		data.pid = json['pid'] is String
				? int.tryParse(json['pid'])
				: json['pid'].toInt();
	}
	if (json['shortname'] != null) {
		data.shortname = json['shortname'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['mergename'] != null) {
		data.mergename = json['mergename'].toString();
	}
	if (json['level'] != null) {
		data.level = json['level'] is String
				? int.tryParse(json['level'])
				: json['level'].toInt();
	}
	if (json['pinyin'] != null) {
		data.pinyin = json['pinyin'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'].toString();
	}
	if (json['zip'] != null) {
		data.zip = json['zip'].toString();
	}
	if (json['first'] != null) {
		data.first = json['first'].toString();
	}
	if (json['lng'] != null) {
		data.lng = json['lng'].toString();
	}
	if (json['lat'] != null) {
		data.lat = json['lat'].toString();
	}
	return data;
}

Map<String, dynamic> cityChoseChildChildToJson(CityChoseChildChild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['pid'] = entity.pid;
	data['shortname'] = entity.shortname;
	data['name'] = entity.name;
	data['mergename'] = entity.mergename;
	data['level'] = entity.level;
	data['pinyin'] = entity.pinyin;
	data['code'] = entity.code;
	data['zip'] = entity.zip;
	data['first'] = entity.first;
	data['lng'] = entity.lng;
	data['lat'] = entity.lat;
	return data;
}