import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class PurchaseNumEntity with JsonConvert<PurchaseNumEntity> {
	@JSONField(name: "should_count")
	int shouldCount;
	@JSONField(name: "already_count")
	int alreadyCount;
	@JSONField(name: "can_count")
	int canCount;
}
