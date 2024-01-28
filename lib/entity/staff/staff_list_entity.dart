import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class StaffListEntity with JsonConvert<StaffListEntity> {
	int count;
	@JSONField(name: "list")
	List<StaffListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class StaffListList with JsonConvert<StaffListList> {
	String avatar;
	int id;
	String username;
	String ifLoginAdmin;
	String identity;
}
