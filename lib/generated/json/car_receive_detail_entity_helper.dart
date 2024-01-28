import 'package:tob/entity/tab_purchase/car_receive_detail_entity.dart';

carReceiveDetailEntityFromJson(CarReceiveDetailEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['carOrderId'] != null) {
		data.carOrderId = json['carOrderId'] is String
				? int.tryParse(json['carOrderId'])
				: json['carOrderId'].toInt();
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
	if (json['enddatetime'] != null) {
		data.enddatetime = json['enddatetime'] is String
				? int.tryParse(json['enddatetime'])
				: json['enddatetime'].toInt();
	}
	if (json['lid'] != null) {
		data.lid = json['lid'] is String
				? int.tryParse(json['lid'])
				: json['lid'].toInt();
	}
	return data;
}

Map<String, dynamic> carReceiveDetailEntityToJson(CarReceiveDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carOrderId'] = entity.carOrderId;
	data['images'] = entity.images;
	data['status'] = entity.status;
	data['sum'] = entity.sum;
	data['updatetime'] = entity.updatetime;
	data['createtime'] = entity.createtime;
	data['remark'] = entity.remark;
	data['enddatetime'] = entity.enddatetime;
	data['lid'] = entity.lid;
	return data;
}