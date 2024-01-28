import 'package:tob/entity/purchase/purchase_file_list_entity.dart';

purchaseFileListEntityFromJson(PurchaseFileListEntity data, Map<String, dynamic> json) {
	if (json['color_name'] != null) {
		data.colorName = json['color_name'].toString();
	}
	if (json['vin'] != null) {
		data.vin = (json['vin'] as List).map((v) => PurchaseFileListVin().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> purchaseFileListEntityToJson(PurchaseFileListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['color_name'] = entity.colorName;
	data['vin'] =  entity.vin?.map((v) => v.toJson())?.toList();
	return data;
}

purchaseFileListVinFromJson(PurchaseFileListVin data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['vin'] != null) {
		data.vin = json['vin'].toString();
	}
	if (json['state'] != null) {
		data.state = json['state'] is String
				? int.tryParse(json['state'])
				: json['state'].toInt();
	}
	if (json['color_id'] != null) {
		data.colorId = json['color_id'] is String
				? int.tryParse(json['color_id'])
				: json['color_id'].toInt();
	}
	if (json['color_name'] != null) {
		data.colorName = json['color_name'].toString();
	}
	return data;
}

Map<String, dynamic> purchaseFileListVinToJson(PurchaseFileListVin entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['vin'] = entity.vin;
	data['state'] = entity.state;
	data['color_id'] = entity.colorId;
	data['color_name'] = entity.colorName;
	return data;
}