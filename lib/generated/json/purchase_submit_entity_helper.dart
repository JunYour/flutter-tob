import 'package:tob/entity/purchase/purchase_submit_entity.dart';

purchaseSubmitEntityFromJson(PurchaseSubmitEntity data, Map<String, dynamic> json) {
	if (json['orderId'] != null) {
		data.orderId = json['orderId'] is String
				? int.tryParse(json['orderId'])
				: json['orderId'].toInt();
	}
	if (json['dealerId'] != null) {
		data.dealerId = json['dealerId'] is String
				? int.tryParse(json['dealerId'])
				: json['dealerId'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['pNum'] != null) {
		data.pNum = json['pNum'].toString();
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
	if (json['priceSum'] != null) {
		data.priceSum = json['priceSum'] is String
				? int.tryParse(json['priceSum'])
				: json['priceSum'].toInt();
	}
	if (json['countSum'] != null) {
		data.countSum = json['countSum'] is String
				? int.tryParse(json['countSum'])
				: json['countSum'].toInt();
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
	if (json['receiveCarStatus'] != null) {
		data.receiveCarStatus = json['receiveCarStatus'].toString();
	}
	if (json['receiveCarImage'] != null) {
		data.receiveCarImage = json['receiveCarImage'].toString();
	}
	if (json['remarks'] != null) {
		data.remarks = json['remarks'].toString();
	}
	if (json['profileId'] != null) {
		data.profileId = json['profileId'] is String
				? int.tryParse(json['profileId'])
				: json['profileId'].toInt();
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
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> purchaseSubmitEntityToJson(PurchaseSubmitEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['orderId'] = entity.orderId;
	data['dealerId'] = entity.dealerId;
	data['status'] = entity.status;
	data['pNum'] = entity.pNum;
	data['mobile'] = entity.mobile;
	data['specId'] = entity.specId;
	data['specName'] = entity.specName;
	data['priceSum'] = entity.priceSum;
	data['countSum'] = entity.countSum;
	data['receiveName'] = entity.receiveName;
	data['receiveMobile'] = entity.receiveMobile;
	data['receiveIdCard'] = entity.receiveIdCard;
	data['receiveZImage'] = entity.receiveZImage;
	data['receiveFImage'] = entity.receiveFImage;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['payVoucherImage'] = entity.payVoucherImage;
	data['payVoucherStatus'] = entity.payVoucherStatus;
	data['receiveCarStatus'] = entity.receiveCarStatus;
	data['receiveCarImage'] = entity.receiveCarImage;
	data['remarks'] = entity.remarks;
	data['profileId'] = entity.profileId;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['id'] = entity.id;
	return data;
}