import 'package:tob/entity/sms_entity.dart';

smsEntityFromJson(SmsEntity data, Map<String, dynamic> json) {
	if (json['RequestId'] != null) {
		data.requestId = json['RequestId'].toString();
	}
	if (json['Message'] != null) {
		data.message = json['Message'].toString();
	}
	if (json['BizId'] != null) {
		data.bizId = json['BizId'].toString();
	}
	if (json['Code'] != null) {
		data.code = json['Code'].toString();
	}
	return data;
}

Map<String, dynamic> smsEntityToJson(SmsEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['RequestId'] = entity.requestId;
	data['Message'] = entity.message;
	data['BizId'] = entity.bizId;
	data['Code'] = entity.code;
	return data;
}