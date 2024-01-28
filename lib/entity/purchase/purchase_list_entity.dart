import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class PurchaseListEntity with JsonConvert<PurchaseListEntity> {
	int count;
	@JSONField(name: "list")
	List<PurchaseListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class PurchaseListList with JsonConvert<PurchaseListList> {
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
	int priceSum;
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
	List<PurchaseListListSpecs> specs;
	bool isshowReceiv;
}

class PurchaseListListSpecs with JsonConvert<PurchaseListListSpecs> {
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
