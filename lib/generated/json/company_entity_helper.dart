import 'package:tob/entity/company_entity.dart';

companyEntityFromJson(CompanyEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['adminId'] != null) {
		data.adminId = json['adminId'] is String
				? int.tryParse(json['adminId'])
				: json['adminId'].toInt();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['creditCode'] != null) {
		data.creditCode = json['creditCode'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['taxNum'] != null) {
		data.taxNum = json['taxNum'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	if (json['tele'] != null) {
		data.tele = json['tele'].toString();
	}
	if (json['bankcode'] != null) {
		data.bankcode = json['bankcode'] is String
				? int.tryParse(json['bankcode'])
				: json['bankcode'].toInt();
	}
	if (json['explain'] != null) {
		data.explain = json['explain'].toString();
	}
	return data;
}

Map<String, dynamic> companyEntityToJson(CompanyEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['adminId'] = entity.adminId;
	data['image'] = entity.image;
	data['name'] = entity.name;
	data['creditCode'] = entity.creditCode;
	data['title'] = entity.title;
	data['taxNum'] = entity.taxNum;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['tele'] = entity.tele;
	data['bankcode'] = entity.bankcode;
	data['explain'] = entity.explain;
	return data;
}