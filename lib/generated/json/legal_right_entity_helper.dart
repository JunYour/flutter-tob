import 'package:tob/entity/vip/legal_right_entity.dart';

legalRightEntityFromJson(LegalRightEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['iconimage'] != null) {
		data.iconimage = json['iconimage'].toString();
	}
	if (json['summary'] != null) {
		data.summary = json['summary'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['vipId'] != null) {
		data.vipId = json['vipId'] is String
				? int.tryParse(json['vipId'])
				: json['vipId'].toInt();
	}
	return data;
}

Map<String, dynamic> legalRightEntityToJson(LegalRightEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['iconimage'] = entity.iconimage;
	data['summary'] = entity.summary;
	data['content'] = entity.content;
	data['status'] = entity.status;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['vipId'] = entity.vipId;
	return data;
}