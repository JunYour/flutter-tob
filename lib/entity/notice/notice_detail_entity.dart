import 'package:tob/generated/json/base/json_convert_content.dart';

class NoticeDetailEntity with JsonConvert<NoticeDetailEntity> {
	int id;
	String summary;
	String title;
	String image;
	String ncontent;
	int type;
	String uids;
	int isjump;
	int jumptype;
	String jumpUrl;
	int status;
	int begintime;
	int endtime;
	int createtime;
	int updatetime;
}
