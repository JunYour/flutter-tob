import 'package:tob/generated/json/base/json_convert_content.dart';

class AddressSingleEntity with JsonConvert<AddressSingleEntity> {
	int id;
	int userId;
	String name;
	String mobile;
	String idcardNum;
	String city;
	String address;
	String idcardImage;
	String createtime;
	String updatetime;
}
