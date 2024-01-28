import 'package:tob/generated/json/base/json_convert_content.dart';

class CarPreOrderEntity with JsonConvert<CarPreOrderEntity> {
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
	String imagefieldIds;
	List<CarPreOrderColors> colors;
}

class CarPreOrderColors with JsonConvert<CarPreOrderColors> {
	int id;
	int carsId;
	int colorId;
	int count;
	int total;
	double perNprice;
	double perPprice;
	String name;
	int num;
}
