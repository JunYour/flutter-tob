import 'package:tob/generated/json/base/json_convert_content.dart';

class LegalRightEntity with JsonConvert<LegalRightEntity> {
	int id;
	String name;
	String iconimage;
	String summary;
	String content;
	String status;
	int createtime;
	int updatetime;
	int vipId;
}
