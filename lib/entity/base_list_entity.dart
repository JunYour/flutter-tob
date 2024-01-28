import 'package:tob/generated/json/base/json_convert_content.dart';

class BaseListEntity with JsonConvert<BaseListEntity> {
	int code;
	String msg;
	List<dynamic> data;
}
