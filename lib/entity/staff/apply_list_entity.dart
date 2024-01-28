import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class ApplyListEntity with JsonConvert<ApplyListEntity> {
	int count;
	@JSONField(name: "list")
	List<ApplyListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class ApplyListList with JsonConvert<ApplyListList> {
	int id;
	int userId;
	int dealerId;
	int status;
	int isDelete;
	String createtime;
	int updatetime;
	String username;
	String avatar;
}
