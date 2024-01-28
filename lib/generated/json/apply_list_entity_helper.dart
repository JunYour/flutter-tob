import 'package:tob/entity/staff/apply_list_entity.dart';

applyListEntityFromJson(ApplyListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => ApplyListList().fromJson(v)).toList();
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

Map<String, dynamic> applyListEntityToJson(ApplyListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	return data;
}

applyListListFromJson(ApplyListList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['dealerId'] != null) {
		data.dealerId = json['dealerId'] is String
				? int.tryParse(json['dealerId'])
				: json['dealerId'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['isDelete'] != null) {
		data.isDelete = json['isDelete'] is String
				? int.tryParse(json['isDelete'])
				: json['isDelete'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'].toString();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['username'] != null) {
		data.username = json['username'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	return data;
}

Map<String, dynamic> applyListListToJson(ApplyListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['dealerId'] = entity.dealerId;
	data['status'] = entity.status;
	data['isDelete'] = entity.isDelete;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['username'] = entity.username;
	data['avatar'] = entity.avatar;
	return data;
}