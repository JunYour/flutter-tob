import 'package:tob/entity/purchase/purchase_file_image_entity.dart';

purchaseFileImageEntityFromJson(PurchaseFileImageEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['carPurchaseId'] != null) {
		data.carPurchaseId = json['carPurchaseId'] is String
				? int.tryParse(json['carPurchaseId'])
				: json['carPurchaseId'].toInt();
	}
	if (json['fieldName'] != null) {
		data.fieldName = json['fieldName'].toString();
	}
	if (json['enable'] != null) {
		data.enable = json['enable'].toString();
	}
	if (json['uploadCount'] != null) {
		data.uploadCount = json['uploadCount'] is String
				? int.tryParse(json['uploadCount'])
				: json['uploadCount'].toInt();
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
	if (json['child'] != null) {
		data.child = PurchaseFileImageChild().fromJson(json['child']);
	}
	if (json['imgs'] != null) {
		data.imgs = json['imgs'].toString();
	}
	return data;
}

Map<String, dynamic> purchaseFileImageEntityToJson(PurchaseFileImageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carPurchaseId'] = entity.carPurchaseId;
	data['fieldName'] = entity.fieldName;
	data['enable'] = entity.enable;
	data['uploadCount'] = entity.uploadCount;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['child'] = entity.child?.toJson();
	data['imgs'] = entity.imgs;
	return data;
}

purchaseFileImageChildFromJson(PurchaseFileImageChild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['orderImageId'] != null) {
		data.orderImageId = json['orderImageId'] is String
				? int.tryParse(json['orderImageId'])
				: json['orderImageId'].toInt();
	}
	if (json['value'] != null) {
		data.value = json['value'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['cause'] != null) {
		data.cause = json['cause'].toString();
	}
	if (json['vinId'] != null) {
		data.vinId = json['vinId'] is String
				? int.tryParse(json['vinId'])
				: json['vinId'].toInt();
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

Map<String, dynamic> purchaseFileImageChildToJson(PurchaseFileImageChild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderImageId'] = entity.orderImageId;
	data['value'] = entity.value;
	data['status'] = entity.status;
	data['cause'] = entity.cause;
	data['vinId'] = entity.vinId;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}