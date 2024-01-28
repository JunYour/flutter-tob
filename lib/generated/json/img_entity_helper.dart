import 'package:tob/entity/img_entity.dart';

imgEntityFromJson(ImgEntity data, Map<String, dynamic> json) {
	if (json['file_url'] != null) {
		data.fileUrl = json['file_url'].toString();
	}
	if (json['file_path'] != null) {
		data.filePath = json['file_path'].toString();
	}
	if (json['file_name'] != null) {
		data.fileName = json['file_name'].toString();
	}
	return data;
}

Map<String, dynamic> imgEntityToJson(ImgEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['file_url'] = entity.fileUrl;
	data['file_path'] = entity.filePath;
	data['file_name'] = entity.fileName;
	return data;
}