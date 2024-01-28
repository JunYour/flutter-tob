import 'package:tob/generated/json/base/json_convert_content.dart';

class PurchaseSubmitEntity with JsonConvert<PurchaseSubmitEntity> {
	int orderId;
	int dealerId;
	String status;
	String pNum;
	String mobile;
	int specId;
	String specName;
	int priceSum;
	int countSum;
	String receiveName;
	String receiveMobile;
	String receiveIdCard;
	String receiveZImage;
	String receiveFImage;
	String city;
	String address;
	String payVoucherImage;
	String payVoucherStatus;
	String receiveCarStatus;
	String receiveCarImage;
	String remarks;
	int profileId;
	int createtime;
	int updatetime;
	int id;
}
