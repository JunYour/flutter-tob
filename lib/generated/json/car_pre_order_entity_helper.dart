import 'package:tob/entity/tab_purchase/car_pre_order_entity.dart';

carPreOrderEntityFromJson(CarPreOrderEntity data, Map<String, dynamic> json) {
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
	if (json['imagefieldIds'] != null) {
		data.imagefieldIds = json['imagefieldIds'].toString();
	}
	if (json['colors'] != null) {
		data.colors = (json['colors'] as List).map((v) => CarPreOrderColors().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> carPreOrderEntityToJson(CarPreOrderEntity entity) {
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
	data['imagefieldIds'] = entity.imagefieldIds;
	data['colors'] =  entity.colors?.map((v) => v.toJson())?.toList();
	return data;
}

carPreOrderColorsFromJson(CarPreOrderColors data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['carsId'] != null) {
		data.carsId = json['carsId'] is String
				? int.tryParse(json['carsId'])
				: json['carsId'].toInt();
	}
	if (json['colorId'] != null) {
		data.colorId = json['colorId'] is String
				? int.tryParse(json['colorId'])
				: json['colorId'].toInt();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	if (json['perNprice'] != null) {
		data.perNprice = json['perNprice'] is String
				? double.tryParse(json['perNprice'])
				: json['perNprice'].toDouble();
	}
	if (json['perPprice'] != null) {
		data.perPprice = json['perPprice'] is String
				? double.tryParse(json['perPprice'])
				: json['perPprice'].toDouble();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['num'] != null) {
		data.num = json['num'] is String
				? int.tryParse(json['num'])
				: json['num'].toInt();
	}
	return data;
}

Map<String, dynamic> carPreOrderColorsToJson(CarPreOrderColors entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carsId'] = entity.carsId;
	data['colorId'] = entity.colorId;
	data['count'] = entity.count;
	data['total'] = entity.total;
	data['perNprice'] = entity.perNprice;
	data['perPprice'] = entity.perPprice;
	data['name'] = entity.name;
	data['num'] = entity.num;
	return data;
}