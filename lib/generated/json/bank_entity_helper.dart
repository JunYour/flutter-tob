import 'package:tob/entity/bank_entity.dart';

bankEntityFromJson(BankEntity data, Map<String, dynamic> json) {
	if (json['bankName'] != null) {
		data.bankName = json['bankName'].toString();
	}
	if (json['receiveName'] != null) {
		data.receiveName = json['receiveName'].toString();
	}
	if (json['bankNum'] != null) {
		data.bankNum = json['bankNum'].toString();
	}
	return data;
}

Map<String, dynamic> bankEntityToJson(BankEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['bankName'] = entity.bankName;
	data['receiveName'] = entity.receiveName;
	data['bankNum'] = entity.bankNum;
	return data;
}