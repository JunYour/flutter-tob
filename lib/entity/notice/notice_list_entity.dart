import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class NoticeListEntity with JsonConvert<NoticeListEntity> {
	int count;
	@JSONField(name: "list")
	List<NoticeListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class NoticeListList with JsonConvert<NoticeListList> {
	int id;
	String summary;
	String title;
	String image;
	String ncontent;
	int type;
	int uid;
	int isjump;
	int jumptype;
	String jumpUrl;
	dynamic extras;
	int status;
	int begintime;
	int endtime;
	String createtime;
	int updatetime;
	@JSONField(name: "is_read")
	int isRead;
}
