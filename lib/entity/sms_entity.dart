import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class SmsEntity with JsonConvert<SmsEntity> {
	@JSONField(name: "RequestId")
	String requestId;
	@JSONField(name: "Message")
	String message;
	@JSONField(name: "BizId")
	String bizId;
	@JSONField(name: "Code")
	String code;
}
