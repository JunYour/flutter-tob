import 'package:tob/entity/update/update_entity.dart';

updateEntityFromJson(UpdateEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['oldversion'] != null) {
		data.oldversion = json['oldversion'].toString();
	}
	if (json['newversion'] != null) {
		data.newversion = json['newversion'].toString();
	}
	if (json['packagesize'] != null) {
		data.packagesize = json['packagesize'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['downloadurl'] != null) {
		data.downloadurl = json['downloadurl'].toString();
	}
	if (json['enforce'] != null) {
		data.enforce = json['enforce'] is String
				? int.tryParse(json['enforce'])
				: json['enforce'].toInt();
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
	if (json['weigh'] != null) {
		data.weigh = json['weigh'] is String
				? int.tryParse(json['weigh'])
				: json['weigh'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['channel'] != null) {
		data.channel = json['channel'].toString();
	}
	return data;
}

Map<String, dynamic> updateEntityToJson(UpdateEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['oldversion'] = entity.oldversion;
	data['newversion'] = entity.newversion;
	data['packagesize'] = entity.packagesize;
	data['content'] = entity.content;
	data['downloadurl'] = entity.downloadurl;
	data['enforce'] = entity.enforce;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['weigh'] = entity.weigh;
	data['status'] = entity.status;
	data['type'] = entity.type;
	data['channel'] = entity.channel;
	return data;
}