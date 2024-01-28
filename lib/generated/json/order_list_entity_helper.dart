import 'package:tob/entity/order/order_list_entity.dart';

orderListEntityFromJson(OrderListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => OrderListList().fromJson(v)).toList();
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

Map<String, dynamic> orderListEntityToJson(OrderListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	return data;
}

orderListListFromJson(OrderListList data, Map<String, dynamic> json) {
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
		data.createtime = json['createtime'].toString();
	}
	if (json['endtime'] != null) {
		data.endtime = json['endtime'] is String
				? int.tryParse(json['endtime'])
				: json['endtime'].toInt();
	}
	if (json['contractNo'] != null) {
		data.contractNo = json['contractNo'].toString();
	}
	if (json['detail'] != null) {
		data.detail = (json['detail'] as List).map((v) => OrderListListDetail().fromJson(v)).toList();
	}
	if (json['brandImg'] != null) {
		data.brandImg = json['brandImg'].toString();
	}
	return data;
}

Map<String, dynamic> orderListListToJson(OrderListList entity) {
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
	data['detail'] =  entity.detail?.map((v) => v.toJson())?.toList();
	data['brandImg'] = entity.brandImg;
	return data;
}

orderListListDetailFromJson(OrderListListDetail data, Map<String, dynamic> json) {
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
		data.perprice = json['perprice'] is String
				? int.tryParse(json['perprice'])
				: json['perprice'].toInt();
	}
	if (json['money'] != null) {
		data.money = json['money'] is String
				? int.tryParse(json['money'])
				: json['money'].toInt();
	}
	if (json['finishSum'] != null) {
		data.finishSum = json['finishSum'] is String
				? int.tryParse(json['finishSum'])
				: json['finishSum'].toInt();
	}
	return data;
}

Map<String, dynamic> orderListListDetailToJson(OrderListListDetail entity) {
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