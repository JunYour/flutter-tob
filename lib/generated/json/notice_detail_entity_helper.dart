import 'package:tob/entity/notice/notice_detail_entity.dart';

noticeDetailEntityFromJson(NoticeDetailEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['summary'] != null) {
		data.summary = json['summary'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	if (json['ncontent'] != null) {
		data.ncontent = json['ncontent'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['uids'] != null) {
		data.uids = json['uids'].toString();
	}
	if (json['isjump'] != null) {
		data.isjump = json['isjump'] is String
				? int.tryParse(json['isjump'])
				: json['isjump'].toInt();
	}
	if (json['jumptype'] != null) {
		data.jumptype = json['jumptype'] is String
				? int.tryParse(json['jumptype'])
				: json['jumptype'].toInt();
	}
	if (json['jumpUrl'] != null) {
		data.jumpUrl = json['jumpUrl'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['begintime'] != null) {
		data.begintime = json['begintime'] is String
				? int.tryParse(json['begintime'])
				: json['begintime'].toInt();
	}
	if (json['endtime'] != null) {
		data.endtime = json['endtime'] is String
				? int.tryParse(json['endtime'])
				: json['endtime'].toInt();
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
	return data;
}

Map<String, dynamic> noticeDetailEntityToJson(NoticeDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['summary'] = entity.summary;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['ncontent'] = entity.ncontent;
	data['type'] = entity.type;
	data['uids'] = entity.uids;
	data['isjump'] = entity.isjump;
	data['jumptype'] = entity.jumptype;
	data['jumpUrl'] = entity.jumpUrl;
	data['status'] = entity.status;
	data['begintime'] = entity.begintime;
	data['endtime'] = entity.endtime;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}