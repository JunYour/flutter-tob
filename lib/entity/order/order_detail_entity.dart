import 'package:tob/generated/json/base/json_convert_content.dart';

class OrderDetailEntity with JsonConvert<OrderDetailEntity> {
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
	int createtime;
	int endtime;
	String contractNo;
	int count;
	List<OrderDetailDetail> detail;
	String brandImg;
	List<OrderDetailContract> contract;
	String zdj;
	String delivery;
	String min;
	String max;
}

class OrderDetailDetail with JsonConvert<OrderDetailDetail> {
	int id;
	int orderId;
	String colorName;
	int colorId;
	int sum;
	String perprice;
	String money;
	int finishSum;
}

class OrderDetailContract with JsonConvert<OrderDetailContract> {
	int id;
	String url;
	int orderId;
	int createtime;
	int isDel;
}
