import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class CarFileListEntity with JsonConvert<CarFileListEntity> {
	@JSONField(name: "color_name")
	String colorName;
	List<CarFileListVin> vin;
}

class CarFileListVin with JsonConvert<CarFileListVin> {
	int id;
	String vin;
	int state;
	@JSONField(name: "color_id")
	int colorId;
	@JSONField(name: "color_name")
	String colorName;
}
