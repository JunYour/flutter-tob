import 'package:tob/entity/bank/bank_account_entity.dart';

bankAccountEntityFromJson(BankAccountEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['bank'] != null) {
		data.bank = json['bank'].toString();
	}
	if (json['account'] != null) {
		data.account = json['account'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
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

Map<String, dynamic> bankAccountEntityToJson(BankAccountEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['bank'] = entity.bank;
	data['account'] = entity.account;
	data['name'] = entity.name;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	return data;
}