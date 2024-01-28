import 'package:tob/entity/tab_purchase/car_file_image_entity.dart';

carFileImageEntityFromJson(CarFileImageEntity data, Map<String, dynamic> json) {
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
		data.child = CarFileImageChild().fromJson(json['child']);
	}
	if (json['imgs'] != null) {
		data.imgs = json['imgs'].toString();
	}
	return data;
}

Map<String, dynamic> carFileImageEntityToJson(CarFileImageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carId'] = entity.carId;
	data['fieldName'] = entity.fieldName;
	data['enable'] = entity.enable;
	data['uploadCount'] = entity.uploadCount;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['child'] = entity.child?.toJson();
	data['imgs'] = entity.imgs;
	return data;
}

carFileImageChildFromJson(CarFileImageChild data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['carImageId'] != null) {
		data.carImageId = json['carImageId'] is String
				? int.tryParse(json['carImageId'])
				: json['carImageId'].toInt();
	}
	if (json['vinId'] != null) {
		data.vinId = json['vinId'] is String
				? int.tryParse(json['vinId'])
				: json['vinId'].toInt();
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

Map<String, dynamic> carFileImageChildToJson(CarFileImageChild entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['carImageId'] = entity.carImageId;
	data['vinId'] = entity.vinId;
	data['value'] = entity.value;
	data['status'] = entity.status;
	data['cause'] = entity.cause;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}