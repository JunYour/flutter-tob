import 'package:tob/entity/order/order_detail_entity.dart';

orderDetailEntityFromJson(OrderDetailEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile'].toString();
	}
	if (json['orderNum'] != null) {
		data.orderNum = json['orderNum'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['dealerId'] != null) {
		data.dealerId = json['dealerId'] is String
				? int.tryParse(json['dealerId'])
				: json['dealerId'].toInt();
	}
	if (json['dealerName'] != null) {
		data.dealerName = json['dealerName'].toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['specId'] != null) {
		data.specId = json['specId'] is String
				? int.tryParse(json['specId'])
				: json['specId'].toInt();
	}
	if (json['specName'] != null) {
		data.specName = json['specName'].toString();
	}
	if (json['countSum'] != null) {
		data.countSum = json['countSum'] is String
				? int.tryParse(json['countSum'])
				: json['countSum'].toInt();
	}
	if (json['priceSum'] != null) {
		data.priceSum = json['priceSum'].toString();
	}
	if (json['deliveryId'] != null) {
		data.deliveryId = json['deliveryId'] is String
				? int.tryParse(json['deliveryId'])
				: json['deliveryId'].toInt();
	}
	if (json['contractId'] != null) {
		data.contractId = json['contractId'].toString();
	}
	if (json['remarks'] != null) {
		data.remarks = json['remarks'].toString();
	}
	if (json['bankName'] != null) {
		data.bankName = json['bankName'].toString();
	}
	if (json['receiveName'] != null) {
		data.receiveName = json['receiveName'].toString();
	}
	if (json['bankNum'] != null) {
		data.bankNum = json['bankNum'].toString();
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
	if (json['endtime'] != null) {
		data.endtime = json['endtime'] is String
				? int.tryParse(json['endtime'])
				: json['endtime'].toInt();
	}
	if (json['contractNo'] != null) {
		data.contractNo = json['contractNo'].toString();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['detail'] != null) {
		data.detail = (json['detail'] as List).map((v) => OrderDetailDetail().fromJson(v)).toList();
	}
	if (json['brandImg'] != null) {
		data.brandImg = json['brandImg'].toString();
	}
	if (json['contract'] != null) {
		data.contract = (json['contract'] as List).map((v) => OrderDetailContract().fromJson(v)).toList();
	}
	if (json['zdj'] != null) {
		data.zdj = json['zdj'].toString();
	}
	if (json['delivery'] != null) {
		data.delivery = json['delivery'].toString();
	}
	if (json['min'] != null) {
		data.min = json['min'].toString();
	}
	if (json['max'] != null) {
		data.max = json['max'].toString();
	}
	return data;
}

Map<String, dynamic> orderDetailEntityToJson(OrderDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['mobile'] = entity.mobile;
	data['orderNum'] = entity.orderNum;
	data['status'] = entity.status;
	data['dealerId'] = entity.dealerId;
	data['dealerName'] = entity.dealerName;
	data['userId'] = entity.userId;
	data['specId'] = entity.specId;
	data['specName'] = entity.specName;
	data['countSum'] = entity.countSum;
	data['priceSum'] = entity.priceSum;
	data['deliveryId'] = entity.deliveryId;
	data['contractId'] = entity.contractId;
	data['remarks'] = entity.remarks;
	data['bankName'] = entity.bankName;
	data['receiveName'] = entity.receiveName;
	data['bankNum'] = entity.bankNum;
	data['updatetime'] = entity.updatetime;
	data['createtime'] = entity.createtime;
	data['endtime'] = entity.endtime;
	data['contractNo'] = entity.contractNo;
	data['count'] = entity.count;
	data['detail'] =  entity.detail?.map((v) => v.toJson())?.toList();
	data['brandImg'] = entity.brandImg;
	data['contract'] =  entity.contract?.map((v) => v.toJson())?.toList();
	data['zdj'] = entity.zdj;
	data['delivery'] = entity.delivery;
	data['min'] = entity.min;
	data['max'] = entity.max;
	return data;
}

orderDetailDetailFromJson(OrderDetailDetail data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId'] is String
				? int.tryParse(json['orderId'])
				: json['orderId'].toInt();
	}
	if (json['colorName'] != null) {
		data.colorName = json['colorName'].toString();
	}
	if (json['colorId'] != null) {
		data.colorId = json['colorId'] is String
				? int.tryParse(json['colorId'])
				: json['colorId'].toInt();
	}
	if (json['sum'] != null) {
		data.sum = json['sum'] is String
				? int.tryParse(json['sum'])
				: json['sum'].toInt();
	}
	if (json['perprice'] != null) {
		data.perprice = json['perprice'].toString();
	}
	if (json['money'] != null) {
		data.money = json['money'].toString();
	}
	if (json['finishSum'] != null) {
		data.finishSum = json['finishSum'] is String
				? int.tryParse(json['finishSum'])
				: json['finishSum'].toInt();
	}
	return data;
}

Map<String, dynamic> orderDetailDetailToJson(OrderDetailDetail entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderId'] = entity.orderId;
	data['colorName'] = entity.colorName;
	data['colorId'] = entity.colorId;
	data['sum'] = entity.sum;
	data['perprice'] = entity.perprice;
	data['money'] = entity.money;
	data['finishSum'] = entity.finishSum;
	return data;
}

orderDetailContractFromJson(OrderDetailContract data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['url'] != null) {
		data.url = json['url'].toString();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId'] is String
				? int.tryParse(json['orderId'])
				: json['orderId'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['isDel'] != null) {
		data.isDel = json['isDel'] is String
				? int.tryParse(json['isDel'])
				: json['isDel'].toInt();
	}
	return data;
}

Map<String, dynamic> orderDetailContractToJson(OrderDetailContract entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['url'] = entity.url;
	data['orderId'] = entity.orderId;
	data['createtime'] = entity.createtime;
	data['isDel'] = entity.isDel;
	return data;
}