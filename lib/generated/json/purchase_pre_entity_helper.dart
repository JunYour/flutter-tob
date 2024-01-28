import 'package:tob/entity/purchase/purchase_pre_entity.dart';

purchasePreEntityFromJson(PurchasePreEntity data, Map<String, dynamic> json) {
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
				? double.tryParse(json['perprice'])
				: json['perprice'].toDouble();
	}
	if (json['money'] != null) {
		data.money = json['money'] is String
				? double.tryParse(json['money'])
				: json['money'].toDouble();
	}
	if (json['num'] != null) {
		data.num = json['num'] is String
				? int.tryParse(json['num'])
				: json['num'].toInt();
	}
	if (json['price'] != null) {
		data.price = json['price'] is String
				? double.tryParse(json['price'])
				: json['price'].toDouble();
	}
	return data;
}

Map<String, dynamic> purchasePreEntityToJson(PurchasePreEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderId'] = entity.orderId;
	data['colorName'] = entity.colorName;
	data['colorId'] = entity.colorId;
	data['sum'] = entity.sum;
	data['perprice'] = entity.perprice;
	data['money'] = entity.money;
	data['num'] = entity.num;
	data['price'] = entity.price;
	return data;
}