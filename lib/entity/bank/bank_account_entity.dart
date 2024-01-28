import 'package:tob/generated/json/base/json_convert_content.dart';

class BankAccountEntity with JsonConvert<BankAccountEntity> {
	int id;
	String bank;
	String account;
	String name;
	int createtime;
	int updatetime;
}
