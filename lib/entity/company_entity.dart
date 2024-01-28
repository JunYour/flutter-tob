import 'package:tob/generated/json/base/json_convert_content.dart';

class CompanyEntity with JsonConvert<CompanyEntity> {
	int id;
	int adminId;
	String image;
	String name;
	String creditCode;
	String title;
	String taxNum;
	String city;
	String address;
	String tele;
	int bankcode;
	String explain;
}
