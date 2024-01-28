import 'package:tob/generated/json/base/json_convert_content.dart';

class BankEntity with JsonConvert<BankEntity> {
	String bankName;
	String receiveName;
	String bankNum;
}
