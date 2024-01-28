import 'package:tob/entity/tab_purchase/tab_purchase_list_entity.dart';

tabPurchaseListEntityFromJson(TabPurchaseListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => TabPurchaseListList().fromJson(v)).toList();
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

Map<String, dynamic> tabPurchaseListEntityToJson(TabPurchaseListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	return data;
}

tabPurchaseListListFromJson(TabPurchaseListList data, Map<String, dynamic> json) {
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
		data.primePrice = json['primePrice'].toString();
	}
	if (json['normalPrice'] != null) {
		data.normalPrice = json['normalPrice'].toString();
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
		data.detailLabels = (json['detailLabels'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	if (json['listLabels'] != null) {
		data.listLabels = (json['listLabels'] as List).map((v) => v.toString()).toList().cast<String>();
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
	if (json['cars'] != null) {
		data.cars = TabPurchaseListListCars().fromJson(json['cars']);
	}
	if (json['indexImage'] != null) {
		data.indexImage = json['indexImage'].toString();
	}
	if (json['salecityName'] != null) {
		data.salecityName = json['salecityName'].toString();
	}
	if (json['carcityName'] != null) {
		data.carcityName = json['carcityName'].toString();
	}
	if (json['colors'] != null) {
		data.colors = (json['colors'] as List).map((v) => TabPurchaseListListColors().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> tabPurchaseListListToJson(TabPurchaseListList entity) {
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
	data['cars'] = entity.cars?.toJson();
	data['indexImage'] = entity.indexImage;
	data['salecityName'] = entity.salecityName;
	data['carcityName'] = entity.carcityName;
	data['colors'] =  entity.colors?.map((v) => v.toJson())?.toList();
	return data;
}

tabPurchaseListListCarsFromJson(TabPurchaseListListCars data, Map<String, dynamic> json) {
	if (json['p_pinpai'] != null) {
		data.pPinpai = json['p_pinpai'].toString();
	}
	if (json['p_chexi'] != null) {
		data.pChexi = json['p_chexi'].toString();
	}
	if (json['p_chexingmingcheng'] != null) {
		data.pChexingmingcheng = json['p_chexingmingcheng'].toString();
	}
	if (json['p_changshangzhidaojia'] != null) {
		data.pChangshangzhidaojia = json['p_changshangzhidaojia'].toString();
	}
	if (json['pChangshangzhidaojiaYuan'] != null) {
		data.pChangshangzhidaojiaYuan = json['pChangshangzhidaojiaYuan'].toString();
	}
	return data;
}

Map<String, dynamic> tabPurchaseListListCarsToJson(TabPurchaseListListCars entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['p_pinpai'] = entity.pPinpai;
	data['p_chexi'] = entity.pChexi;
	data['p_chexingmingcheng'] = entity.pChexingmingcheng;
	data['p_changshangzhidaojia'] = entity.pChangshangzhidaojia;
	data['pChangshangzhidaojiaYuan'] = entity.pChangshangzhidaojiaYuan;
	return data;
}

tabPurchaseListListColorsFromJson(TabPurchaseListListColors data, Map<String, dynamic> json) {
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
				? int.tryParse(json['perNprice'])
				: json['perNprice'].toInt();
	}
	if (json['perPprice'] != null) {
		data.perPprice = json['perPprice'] is String
				? int.tryParse(json['perPprice'])
				: json['perPprice'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	return data;
}

Map<String, dynamic> tabPurchaseListListColorsToJson(TabPurchaseListListColors entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carsId'] = entity.carsId;
	data['colorId'] = entity.colorId;
	data['count'] = entity.count;
	data['total'] = entity.total;
	data['perNprice'] = entity.perNprice;
	data['perPprice'] = entity.perPprice;
	data['name'] = entity.name;
	return data;
}