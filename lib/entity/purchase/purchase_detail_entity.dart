import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class PurchaseDetailEntity with JsonConvert<PurchaseDetailEntity> {
	int id;
	int orderId;
	int updatetime;
	String createtime;
	String status;
	String pNum;
	int dealerId;
	String mobile;
	int specId;
	String specName;
	String remarks;
	int countSum;
	double priceSum;
	String receiveName;
	String receiveMobile;
	String receiveIdCard;
	String receiveZImage;
	String receiveFImage;
	String city;
	String address;
	String payVoucherImage;
	String payVoucherStatus;
	String receiveCarImage;
	String receiveCarStatus;
	String payVoucherRemark;
	int addressId;
	List<PurchaseDetailSpecs> specs;
	bool isshowReceiv;
}

class PurchaseDetailSpecs with JsonConvert<PurchaseDetailSpecs> {
	int id;
	@JSONField(name: "purchase_id")
	int purchaseId;
	@JSONField(name: "color_id")
	int colorId;
	@JSONField(name: "color_name")
	String colorName;
	String perprice;
	String count;
	String price;
}
