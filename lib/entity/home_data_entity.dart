import 'package:tob/generated/json/base/json_convert_content.dart';

class HomeDataEntity with JsonConvert<HomeDataEntity> {
	String type;
	String extra;
	List<dynamic> data;
}
