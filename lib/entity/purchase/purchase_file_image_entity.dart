import 'package:tob/generated/json/base/json_convert_content.dart';

class PurchaseFileImageEntity with JsonConvert<PurchaseFileImageEntity> {
	int id;
	int carPurchaseId;
	String fieldName;
	String enable;
	int uploadCount;
	int createtime;
	int updatetime;
	PurchaseFileImageChild child;
	String imgs;
}

class PurchaseFileImageChild with JsonConvert<PurchaseFileImageChild> {
	int id;
	int orderImageId;
	String value;
	String status;
	String cause;
	int vinId;
	int createtime;
	int updatetime;
}
