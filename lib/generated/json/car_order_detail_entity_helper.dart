import 'package:tob/entity/tab_purchase/car_order_detail_entity.dart';

carOrderDetailEntityFromJson(CarOrderDetailEntity data, Map<String, dynamic> json) {
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
	if (json['carId'] != null) {
		data.carId = json['carId'] is String
				? int.tryParse(json['carId'])
				: json['carId'].toInt();
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
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
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
		data.countSum = json['countSum'].toString();
	}
	if (json['priceNSum'] != null) {
		data.priceNSum = json['priceNSum'].toString();
	}
	if (json['pricePSum'] != null) {
		data.pricePSum = json['pricePSum'].toString();
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
	if (json['receiveCarRemarks'] != null) {
		data.receiveCarRemarks = json['receiveCarRemarks'].toString();
	}
	if (json['payVoucherRemark'] != null) {
		data.payVoucherRemark = json['payVoucherRemark'].toString();
	}
	if (json['addressId'] != null) {
		data.addressId = json['addressId'] is String
				? int.tryParse(json['addressId'])
				: json['addressId'].toInt();
	}
	if (json['isDel'] != null) {
		data.isDel = json['isDel'] is String
				? int.tryParse(json['isDel'])
				: json['isDel'].toInt();
	}
	if (json['lid'] != null) {
		data.lid = json['lid'] is String
				? int.tryParse(json['lid'])
				: json['lid'].toInt();
	}
	if (json['endtime'] != null) {
		data.endtime = json['endtime'] is String
				? int.tryParse(json['endtime'])
				: json['endtime'].toInt();
	}
	if (json['sendcartime'] != null) {
		data.sendcartime = json['sendcartime'] is String
				? int.tryParse(json['sendcartime'])
				: json['sendcartime'].toInt();
	}
	if (json['oSendcartime'] != null) {
		data.oSendcartime = json['oSendcartime'] is String
				? int.tryParse(json['oSendcartime'])
				: json['oSendcartime'].toInt();
	}
	if (json['bankId'] != null) {
		data.bankId = json['bankId'] is String
				? int.tryParse(json['bankId'])
				: json['bankId'].toInt();
	}
	if (json['adminId'] != null) {
		data.adminId = json['adminId'] is String
				? int.tryParse(json['adminId'])
				: json['adminId'].toInt();
	}
	if (json['zhidaojia'] != null) {
		data.zhidaojia = json['zhidaojia'];
	}
	if (json['colors'] != null) {
		data.colors = (json['colors'] as List).map((v) => CarOrderDetailColors().fromJson(v)).toList();
	}
	if (json['car'] != null) {
		data.car = CarOrderDetailCar().fromJson(json['car']);
	}
	if (json['normalPrice'] != null) {
		data.normalPrice = json['normalPrice'].toString();
	}
	if (json['primePrice'] != null) {
		data.primePrice = json['primePrice'].toString();
	}
	if (json['contract'] != null) {
		data.contract = CarOrderDetailContract().fromJson(json['contract']);
	}
	return data;
}

Map<String, dynamic> carOrderDetailEntityToJson(CarOrderDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['carId'] = entity.carId;
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
	data['priceNSum'] = entity.priceNSum;
	data['pricePSum'] = entity.pricePSum;
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
	data['receiveCarRemarks'] = entity.receiveCarRemarks;
	data['payVoucherRemark'] = entity.payVoucherRemark;
	data['addressId'] = entity.addressId;
	data['isDel'] = entity.isDel;
	data['lid'] = entity.lid;
	data['endtime'] = entity.endtime;
	data['sendcartime'] = entity.sendcartime;
	data['oSendcartime'] = entity.oSendcartime;
	data['bankId'] = entity.bankId;
	data['adminId'] = entity.adminId;
	data['zhidaojia'] = entity.zhidaojia;
	data['colors'] =  entity.colors?.map((v) => v.toJson())?.toList();
	data['car'] = entity.car?.toJson();
	data['normalPrice'] = entity.normalPrice;
	data['primePrice'] = entity.primePrice;
	data['contract'] = entity.contract?.toJson();
	return data;
}

carOrderDetailColorsFromJson(CarOrderDetailColors data, Map<String, dynamic> json) {
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
	if (json['perNprice'] != null) {
		data.perNprice = json['perNprice'] is String
				? double.tryParse(json['perNprice'])
				: json['perNprice'].toDouble();
	}
	if (json['money'] != null) {
		data.money = json['money'] is String
				? double.tryParse(json['money'])
				: json['money'].toDouble();
	}
	if (json['perPprice'] != null) {
		data.perPprice = json['perPprice'] is String
				? double.tryParse(json['perPprice'])
				: json['perPprice'].toDouble();
	}
	return data;
}

Map<String, dynamic> carOrderDetailColorsToJson(CarOrderDetailColors entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['purchaseId'] = entity.purchaseId;
	data['colorName'] = entity.colorName;
	data['colorId'] = entity.colorId;
	data['sum'] = entity.sum;
	data['perNprice'] = entity.perNprice;
	data['money'] = entity.money;
	data['perPprice'] = entity.perPprice;
	return data;
}

carOrderDetailCarFromJson(CarOrderDetailCar data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['carId'] != null) {
		data.carId = json['carId'] is String
				? int.tryParse(json['carId'])
				: json['carId'].toInt();
	}
	if (json['brandId'] != null) {
		data.brandId = json['brandId'] is String
				? int.tryParse(json['brandId'])
				: json['brandId'].toInt();
	}
	if (json['seriesId'] != null) {
		data.seriesId = json['seriesId'] is String
				? int.tryParse(json['seriesId'])
				: json['seriesId'].toInt();
	}
	if (json['carName'] != null) {
		data.carName = json['carName'].toString();
	}
	if (json['seriesName'] != null) {
		data.seriesName = json['seriesName'].toString();
	}
	if (json['brandName'] != null) {
		data.brandName = json['brandName'].toString();
	}
	if (json['primePrice'] != null) {
		data.primePrice = json['primePrice'] is String
				? double.tryParse(json['primePrice'])
				: json['primePrice'].toDouble();
	}
	if (json['normalPrice'] != null) {
		data.normalPrice = json['normalPrice'] is String
				? double.tryParse(json['normalPrice'])
				: json['normalPrice'].toDouble();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	if (json['buycount'] != null) {
		data.buycount = json['buycount'] is String
				? int.tryParse(json['buycount'])
				: json['buycount'].toInt();
	}
	if (json['images'] != null) {
		data.images = json['images'].toString();
	}
	if (json['pubTime'] != null) {
		data.pubTime = json['pubTime'] is String
				? int.tryParse(json['pubTime'])
				: json['pubTime'].toInt();
	}
	if (json['expire'] != null) {
		data.expire = json['expire'].toString();
	}
	if (json['carcity'] != null) {
		data.carcity = json['carcity'].toString();
	}
	if (json['salecity'] != null) {
		data.salecity = json['salecity'].toString();
	}
	if (json['detailLabels'] != null) {
		data.detailLabels = json['detailLabels'].toString();
	}
	if (json['listLabels'] != null) {
		data.listLabels = json['listLabels'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['deliveryStatus'] != null) {
		data.deliveryStatus = json['deliveryStatus'] is String
				? int.tryParse(json['deliveryStatus'])
				: json['deliveryStatus'].toInt();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'].toString();
	}
	if (json['carcityType'] != null) {
		data.carcityType = json['carcityType'].toString();
	}
	if (json['salecityType'] != null) {
		data.salecityType = json['salecityType'].toString();
	}
	if (json['imagefieldIds'] != null) {
		data.imagefieldIds = json['imagefieldIds'].toString();
	}
	if (json['imgIndex'] != null) {
		data.imgIndex = json['imgIndex'].toString();
	}
	return data;
}

Map<String, dynamic> carOrderDetailCarToJson(CarOrderDetailCar entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carId'] = entity.carId;
	data['brandId'] = entity.brandId;
	data['seriesId'] = entity.seriesId;
	data['carName'] = entity.carName;
	data['seriesName'] = entity.seriesName;
	data['brandName'] = entity.brandName;
	data['primePrice'] = entity.primePrice;
	data['normalPrice'] = entity.normalPrice;
	data['total'] = entity.total;
	data['buycount'] = entity.buycount;
	data['images'] = entity.images;
	data['pubTime'] = entity.pubTime;
	data['expire'] = entity.expire;
	data['carcity'] = entity.carcity;
	data['salecity'] = entity.salecity;
	data['detailLabels'] = entity.detailLabels;
	data['listLabels'] = entity.listLabels;
	data['status'] = entity.status;
	data['deliveryStatus'] = entity.deliveryStatus;
	data['remark'] = entity.remark;
	data['carcityType'] = entity.carcityType;
	data['salecityType'] = entity.salecityType;
	data['imagefieldIds'] = entity.imagefieldIds;
	data['imgIndex'] = entity.imgIndex;
	return data;
}

carOrderDetailContractFromJson(CarOrderDetailContract data, Map<String, dynamic> json) {
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
	if (json['contract'] != null) {
		data.contract = json['contract'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['lid'] != null) {
		data.lid = json['lid'] is String
				? int.tryParse(json['lid'])
				: json['lid'].toInt();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'].toString();
	}
	if (json['contractNo'] != null) {
		data.contractNo = json['contractNo'].toString();
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
	return data;
}

Map<String, dynamic> carOrderDetailContractToJson(CarOrderDetailContract entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carOrderId'] = entity.carOrderId;
	data['contract'] = entity.contract;
	data['status'] = entity.status;
	data['lid'] = entity.lid;
	data['remark'] = entity.remark;
	data['contractNo'] = entity.contractNo;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}