import 'package:tob/entity/notice/notice_count_entity.dart';

noticeCountEntityFromJson(NoticeCountEntity data, Map<String, dynamic> json) {
	if (json['notice'] != null) {
		data.notice = json['notice'] is String
				? int.tryParse(json['notice'])
				: json['notice'].toInt();
	}
	if (json['brocast'] != null) {
		data.brocast = json['brocast'] is String
				? int.tryParse(json['brocast'])
				: json['brocast'].toInt();
	}
	return data;
}

Map<String, dynamic> noticeCountEntityToJson(NoticeCountEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['notice'] = entity.notice;
	data['brocast'] = entity.brocast;
	return data;
}