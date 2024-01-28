import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class CarOrderListEntity with JsonConvert<CarOrderListEntity> {
	int count;
	@JSONField(name: "list")
	List<CarOrderListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class CarOrderListList with JsonConvert<CarOrderListList> {
	int id;
	int userId;
	int carId;
	int updatetime;
	String createtime;
	int status;
	String pNum;
	int dealerId;
	String mobile;
	int specId;
	String specName;
	String remarks;
	String countSum;
	String priceNSum;
	String pricePSum;
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
	String receiveCarRemarks;
	String payVoucherRemark;
	int addressId;
	int isDel;
	int lid;
	int endtime;
	int sendcartime;
	int oSendcartime;
	int bankId;
	int adminId;
	List<CarOrderListListColors> colors;
	CarOrderListListContract contract;
}

class CarOrderListListColors with JsonConvert<CarOrderListListColors> {
	int id;
	int purchaseId;
	String colorName;
	int colorId;
	int sum;
	double perNprice;
	double money;
	double perPprice;
}

class CarOrderListListContract with JsonConvert<CarOrderListListContract> {
	int id;
	int carOrderId;
	String contract;
	int status;
	int lid;
	String remark;
	String contractNo;
	int createtime;
	int updatetime;
}
