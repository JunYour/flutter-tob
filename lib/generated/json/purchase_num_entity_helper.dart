import 'package:tob/entity/purchase/purchase_num_entity.dart';

purchaseNumEntityFromJson(PurchaseNumEntity data, Map<String, dynamic> json) {
	if (json['should_count'] != null) {
		data.shouldCount = json['should_count'] is String
				? int.tryParse(json['should_count'])
				: json['should_count'].toInt();
	}
	if (json['already_count'] != null) {
		data.alreadyCount = json['already_count'] is String
				? int.tryParse(json['already_count'])
				: json['already_count'].toInt();
	}
	if (json['can_count'] != null) {
		data.canCount = json['can_count'] is String
				? int.tryParse(json['can_count'])
				: json['can_count'].toInt();
	}
	return data;
}

Map<String, dynamic> purchaseNumEntityToJson(PurchaseNumEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['should_count'] = entity.shouldCount;
	data['already_count'] = entity.alreadyCount;
	data['can_count'] = entity.canCount;
	return data;
}