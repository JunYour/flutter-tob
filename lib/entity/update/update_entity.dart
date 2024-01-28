import 'package:tob/generated/json/base/json_convert_content.dart';

class UpdateEntity with JsonConvert<UpdateEntity> {
	int id;
	String oldversion;
	String newversion;
	String packagesize;
	String content;
	String downloadurl;
	int enforce;
	int createtime;
	int updatetime;
	int weigh;
	String status;
	String type;
	String channel;
}
