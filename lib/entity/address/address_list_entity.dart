import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class AddressListEntity with JsonConvert<AddressListEntity> {
	int count;
	@JSONField(name: "list")
	List<AddressListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class AddressListList with JsonConvert<AddressListList> {
	int id;
	int userId;
	String name;
	String mobile;
	String idcardNum;
	String city;
	String address;
	String idcardImage;
}
