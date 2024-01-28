import 'package:tob/generated/json/base/json_convert_content.dart';

class BaseDataEntity with JsonConvert<BaseDataEntity> {
	int id;
	String name;
	String group;
	String title;
	String tip;
	String type;
	String value;
	String content;
	String rule;
	String extend;
	String setting;
}
