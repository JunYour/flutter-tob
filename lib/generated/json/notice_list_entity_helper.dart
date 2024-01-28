import 'package:tob/entity/notice/notice_list_entity.dart';

noticeListEntityFromJson(NoticeListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => NoticeListList().fromJson(v)).toList();
	}
	if (json['page'] != null) {
		data.page = json['page'] is String
				? int.tryParse(json['page'])
				: json['page'].toInt();
	}
	if (json['perPage'] != null) {
		data.perPage = json['perPage'] is String
				? int.tryParse(json['perPage'])
				: json['perPage'].toInt();
	}
	if (json['pageCount'] != null) {
		data.pageCount = json['pageCount'] is String
				? int.tryParse(json['pageCount'])
				: json['pageCount'].toInt();
	}
	return data;
}

Map<String, dynamic> noticeListEntityToJson(NoticeListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	return data;
}

noticeListListFromJson(NoticeListList data, Map<String, dynamic> json) {
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
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
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
	if (json['extras'] != null) {
		data.extras = json['extras'];
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
		data.createtime = json['createtime'].toString();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['is_read'] != null) {
		data.isRead = json['is_read'] is String
				? int.tryParse(json['is_read'])
				: json['is_read'].toInt();
	}
	return data;
}

Map<String, dynamic> noticeListListToJson(NoticeListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['summary'] = entity.summary;
	data['title'] = entity.title;
	data['image'] = entity.image;
	data['ncontent'] = entity.ncontent;
	data['type'] = entity.type;
	data['uid'] = entity.uid;
	data['isjump'] = entity.isjump;
	data['jumptype'] = entity.jumptype;
	data['jumpUrl'] = entity.jumpUrl;
	data['extras'] = entity.extras;
	data['status'] = entity.status;
	data['begintime'] = entity.begintime;
	data['endtime'] = entity.endtime;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['is_read'] = entity.isRead;
	return data;
}