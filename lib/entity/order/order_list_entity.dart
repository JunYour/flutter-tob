import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class OrderListEntity with JsonConvert<OrderListEntity> {
	int count;
	@JSONField(name: "list")
	List<OrderListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class OrderListList with JsonConvert<OrderListList> {
	int id;
	String mobile;
	String orderNum;
	int status;
	int dealerId;
	String dealerName;
	int userId;
	int specId;
	String specName;
	int countSum;
	String priceSum;
	int deliveryId;
	String contractId;
	String remarks;
	String bankName;
	String receiveName;
	String bankNum;
	int updatetime;
	String createtime;
	int endtime;
	String contractNo;
	List<OrderListListDetail> detail;
	String brandImg;
}

class OrderListListDetail with JsonConvert<OrderListListDetail> {
	int id;
	int orderId;
	String colorName;
	int colorId;
	int sum;
	int perprice;
	int money;
	int finishSum;
}
