import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class TabPurchaseListEntity with JsonConvert<TabPurchaseListEntity> {
	int count;
	@JSONField(name: "list")
	List<TabPurchaseListList> xList;
	int page;
	int perPage;
	int pageCount;
}

class TabPurchaseListList with JsonConvert<TabPurchaseListList> {
	int id;
	int carId;
	int brandId;
	int seriesId;
	String carName;
	String seriesName;
	String brandName;
	String primePrice;
	String normalPrice;
	int total;
	int buycount;
	String images;
	int pubTime;
	String expire;
	String carcity;
	String salecity;
	List<String> detailLabels;
	List<String> listLabels;
	int status;
	int deliveryStatus;
	String remark;
	TabPurchaseListListCars cars;
	String indexImage;
	String salecityName;
	String carcityName;
	List<TabPurchaseListListColors> colors;
}

class TabPurchaseListListCars with JsonConvert<TabPurchaseListListCars> {
	@JSONField(name: "p_pinpai")
	String pPinpai;
	@JSONField(name: "p_chexi")
	String pChexi;
	@JSONField(name: "p_chexingmingcheng")
	String pChexingmingcheng;
	@JSONField(name: "p_changshangzhidaojia")
	String pChangshangzhidaojia;
	@JSONField(name: "pChangshangzhidaojiaYuan")
	String pChangshangzhidaojiaYuan;
}

class TabPurchaseListListColors with JsonConvert<TabPurchaseListListColors> {
	int id;
	int carsId;
	int colorId;
	int count;
	int total;
	int perNprice;
	int perPprice;
	String name;
}
