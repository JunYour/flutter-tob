import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class PurchaseFileListEntity with JsonConvert<PurchaseFileListEntity> {
	@JSONField(name: "color_name")
	String colorName;
	List<PurchaseFileListVin> vin;
}

class PurchaseFileListVin with JsonConvert<PurchaseFileListVin> {
	int id;
	String vin;
	int state;
	@JSONField(name: "color_id")
	int colorId;
	@JSONField(name: "color_name")
	String colorName;
}
