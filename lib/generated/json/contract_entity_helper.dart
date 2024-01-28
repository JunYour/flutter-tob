import 'package:tob/entity/tab_purchase/contract_entity.dart';

contractEntityFromJson(ContractEntity data, Map<String, dynamic> json) {
	if (json['contract'] != null) {
		data.contract = ContractContract().fromJson(json['contract']);
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['contractUrl'] != null) {
		data.contractUrl = json['contractUrl'].toString();
	}
	if (json['main'] != null) {
		data.main = ContractMain().fromJson(json['main']);
	}
	return data;
}

Map<String, dynamic> contractEntityToJson(ContractEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['contract'] = entity.contract?.toJson();
	data['title'] = entity.title;
	data['contractUrl'] = entity.contractUrl;
	data['main'] = entity.main?.toJson();
	return data;
}

contractContractFromJson(ContractContract data, Map<String, dynamic> json) {
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

Map<String, dynamic> contractContractToJson(ContractContract entity) {
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

contractMainFromJson(ContractMain data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	return data;
}

Map<String, dynamic> contractMainToJson(ContractMain entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['phone'] = entity.phone;
	data['address'] = entity.address;
	return data;
}