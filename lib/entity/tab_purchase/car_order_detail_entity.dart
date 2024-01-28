import 'package:tob/generated/json/base/json_convert_content.dart';

class CarOrderDetailEntity with JsonConvert<CarOrderDetailEntity> {
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
	dynamic zhidaojia;
	List<CarOrderDetailColors> colors;
	CarOrderDetailCar car;
	String normalPrice;
	String primePrice;
	CarOrderDetailContract contract;
}

class CarOrderDetailColors with JsonConvert<CarOrderDetailColors> {
	int id;
	int purchaseId;
	String colorName;
	int colorId;
	int sum;
	double perNprice;
	double money;
	double perPprice;
}

class CarOrderDetailCar with JsonConvert<CarOrderDetailCar> {
	int id;
	int carId;
	int brandId;
	int seriesId;
	String carName;
	String seriesName;
	String brandName;
	double primePrice;
	double normalPrice;
	int total;
	int buycount;
	String images;
	int pubTime;
	String expire;
	String carcity;
	String salecity;
	String detailLabels;
	String listLabels;
	int status;
	int deliveryStatus;
	String remark;
	String carcityType;
	String salecityType;
	String imagefieldIds;
	String imgIndex;
}

class CarOrderDetailContract with JsonConvert<CarOrderDetailContract> {
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
