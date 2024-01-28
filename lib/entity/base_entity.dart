import 'package:tob/generated/json/base/json_convert_content.dart';

class BaseEntity with JsonConvert<BaseEntity> {
	int code;
	String msg;
	dynamic data;
	get other => null;
}
