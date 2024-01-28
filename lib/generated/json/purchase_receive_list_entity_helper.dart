import 'package:tob/entity/purchase/purchase_receive_list_entity.dart';

purchaseReceiveListEntityFromJson(PurchaseReceiveListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => PurchaseReceiveListList().fromJson(v)).toList();
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
	if (json['al_receiv'] != null) {
		data.alReceiv = json['al_receiv'] is String
				? int.tryParse(json['al_receiv'])
				: json['al_receiv'].toInt();
	}
	if (json['sh_receiv'] != null) {
		data.shReceiv = json['sh_receiv'] is String
				? int.tryParse(json['sh_receiv'])
				: json['sh_receiv'].toInt();
	}
	if (json['can_receiv'] != null) {
		data.canReceiv = json['can_receiv'] is String
				? int.tryParse(json['can_receiv'])
				: json['can_receiv'].toInt();
	}
	return data;
}

Map<String, dynamic> purchaseReceiveListEntityToJson(PurchaseReceiveListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	data['al_receiv'] = entity.alReceiv;
	data['sh_receiv'] = entity.shReceiv;
	data['can_receiv'] = entity.canReceiv;
	return data;
}

purchaseReceiveListListFromJson(PurchaseReceiveListList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['purchaseId'] != null) {
		data.purchaseId = json['purchaseId'] is String
				? int.tryParse(json['purchaseId'])
				: json['purchaseId'].toInt();
	}
	if (json['images'] != null) {
		data.images = json['images'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['sum'] != null) {
		data.sum = json['sum'].toString();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'].toString();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'].toString();
	}
	return data;
}

Map<String, dynamic> purchaseReceiveListListToJson(PurchaseReceiveListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['purchaseId'] = entity.purchaseId;
	data['images'] = entity.images;
	data['status'] = entity.status;
	data['sum'] = entity.sum;
	data['updatetime'] = entity.updatetime;
	data['createtime'] = entity.createtime;
	data['remark'] = entity.remark;
	return data;
}