import 'package:tob/generated/json/base/json_convert_content.dart';

class PurchasePreEntity with JsonConvert<PurchasePreEntity> {
	int id;
	int orderId;
	String colorName;
	int colorId;
	int sum;
	double perprice;
	double money;
	int num;
	double price;
}
