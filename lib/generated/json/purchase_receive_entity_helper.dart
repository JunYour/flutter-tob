import 'package:tob/entity/purchase/purchase_receive_entity.dart';

purchaseReceiveEntityFromJson(PurchaseReceiveEntity data, Map<String, dynamic> json) {
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
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'].toString();
	}
	return data;
}

Map<String, dynamic> purchaseReceiveEntityToJson(PurchaseReceiveEntity entity) {
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