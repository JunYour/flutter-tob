import 'package:tob/entity/address/address_single_entity.dart';

addressSingleEntityFromJson(AddressSingleEntity data, Map<String, dynamic> json) {
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
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile'].toString();
	}
	if (json['idcardNum'] != null) {
		data.idcardNum = json['idcardNum'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	if (json['idcardImage'] != null) {
		data.idcardImage = json['idcardImage'].toString();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'].toString();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'].toString();
	}
	return data;
}

Map<String, dynamic> addressSingleEntityToJson(AddressSingleEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['name'] = entity.name;
	data['mobile'] = entity.mobile;
	data['idcardNum'] = entity.idcardNum;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['idcardImage'] = entity.idcardImage;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}