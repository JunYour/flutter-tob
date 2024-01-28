import 'package:tob/entity/address/address_list_entity.dart';

addressListEntityFromJson(AddressListEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => AddressListList().fromJson(v)).toList();
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

Map<String, dynamic> addressListEntityToJson(AddressListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['count'] = entity.count;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['page'] = entity.page;
	data['perPage'] = entity.perPage;
	data['pageCount'] = entity.pageCount;
	return data;
}

addressListListFromJson(AddressListList data, Map<String, dynamic> json) {
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
	return data;
}

Map<String, dynamic> addressListListToJson(AddressListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['name'] = entity.name;
	data['mobile'] = entity.mobile;
	data['idcardNum'] = entity.idcardNum;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['idcardImage'] = entity.idcardImage;
	return data;
}