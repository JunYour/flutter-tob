import 'package:tob/entity/purchase/purchase_detail_entity.dart';

purchaseDetailEntityFromJson(PurchaseDetailEntity data, Map<String, dynamic> json) {
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
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['pNum'] != null) {
		data.pNum = json['pNum'].toString();
	}
	if (json['dealerId'] != null) {
		data.dealerId = json['dealerId'] is String
				? int.tryParse(json['dealerId'])
				: json['dealerId'].toInt();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile'].toString();
	}
	if (json['specId'] != null) {
		data.specId = json['specId'] is String
				? int.tryParse(json['specId'])
				: json['specId'].toInt();
	}
	if (json['specName'] != null) {
		data.specName = json['specName'].toString();
	}
	if (json['remarks'] != null) {
		data.remarks = json['remarks'].toString();
	}
	if (json['countSum'] != null) {
		data.countSum = json['countSum'] is String
				? int.tryParse(json['countSum'])
				: json['countSum'].toInt();
	}
	if (json['priceSum'] != null) {
		data.priceSum = json['priceSum'] is String
				? double.tryParse(json['priceSum'])
				: json['priceSum'].toDouble();
	}
	if (json['receiveName'] != null) {
		data.receiveName = json['receiveName'].toString();
	}
	if (json['receiveMobile'] != null) {
		data.receiveMobile = json['receiveMobile'].toString();
	}
	if (json['receiveIdCard'] != null) {
		data.receiveIdCard = json['receiveIdCard'].toString();
	}
	if (json['receiveZImage'] != null) {
		data.receiveZImage = json['receiveZImage'].toString();
	}
	if (json['receiveFImage'] != null) {
		data.receiveFImage = json['receiveFImage'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	if (json['payVoucherImage'] != null) {
		data.payVoucherImage = json['payVoucherImage'].toString();
	}
	if (json['payVoucherStatus'] != null) {
		data.payVoucherStatus = json['payVoucherStatus'].toString();
	}
	if (json['receiveCarImage'] != null) {
		data.receiveCarImage = json['receiveCarImage'].toString();
	}
	if (json['receiveCarStatus'] != null) {
		data.receiveCarStatus = json['receiveCarStatus'].toString();
	}
	if (json['payVoucherRemark'] != null) {
		data.payVoucherRemark = json['payVoucherRemark'].toString();
	}
	if (json['addressId'] != null) {
		data.addressId = json['addressId'] is String
				? int.tryParse(json['addressId'])
				: json['addressId'].toInt();
	}
	if (json['specs'] != null) {
		data.specs = (json['specs'] as List).map((v) => PurchaseDetailSpecs().fromJson(v)).toList();
	}
	if (json['isshowReceiv'] != null) {
		data.isshowReceiv = json['isshowReceiv'];
	}
	return data;
}

Map<String, dynamic> purchaseDetailEntityToJson(PurchaseDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderId'] = entity.orderId;
	data['updatetime'] = entity.updatetime;
	data['createtime'] = entity.createtime;
	data['status'] = entity.status;
	data['pNum'] = entity.pNum;
	data['dealerId'] = entity.dealerId;
	data['mobile'] = entity.mobile;
	data['specId'] = entity.specId;
	data['specName'] = entity.specName;
	data['remarks'] = entity.remarks;
	data['countSum'] = entity.countSum;
	data['priceSum'] = entity.priceSum;
	data['receiveName'] = entity.receiveName;
	data['receiveMobile'] = entity.receiveMobile;
	data['receiveIdCard'] = entity.receiveIdCard;
	data['receiveZImage'] = entity.receiveZImage;
	data['receiveFImage'] = entity.receiveFImage;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['payVoucherImage'] = entity.payVoucherImage;
	data['payVoucherStatus'] = entity.payVoucherStatus;
	data['receiveCarImage'] = entity.receiveCarImage;
	data['receiveCarStatus'] = entity.receiveCarStatus;
	data['payVoucherRemark'] = entity.payVoucherRemark;
	data['addressId'] = entity.addressId;
	data['specs'] =  entity.specs?.map((v) => v.toJson())?.toList();
	data['isshowReceiv'] = entity.isshowReceiv;
	return data;
}

purchaseDetailSpecsFromJson(PurchaseDetailSpecs data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['purchase_id'] != null) {
		data.purchaseId = json['purchase_id'] is String
				? int.tryParse(json['purchase_id'])
				: json['purchase_id'].toInt();
	}
	if (json['color_id'] != null) {
		data.colorId = json['color_id'] is String
				? int.tryParse(json['color_id'])
				: json['color_id'].toInt();
	}
	if (json['color_name'] != null) {
		data.colorName = json['color_name'].toString();
	}
	if (json['perprice'] != null) {
		data.perprice = json['perprice'].toString();
	}
	if (json['count'] != null) {
		data.count = json['count'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'].toString();
	}
	return data;
}

Map<String, dynamic> purchaseDetailSpecsToJson(PurchaseDetailSpecs entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['purchase_id'] = entity.purchaseId;
	data['color_id'] = entity.colorId;
	data['color_name'] = entity.colorName;
	data['perprice'] = entity.perprice;
	data['count'] = entity.count;
	data['price'] = entity.price;
	return data;
}