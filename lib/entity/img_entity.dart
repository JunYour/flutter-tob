import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class ImgEntity with JsonConvert<ImgEntity> {
	@JSONField(name: "file_url")
	String fileUrl;
	@JSONField(name: "file_path")
	String filePath;
	@JSONField(name: "file_name")
	String fileName;
}
