import 'package:tob/generated/json/base/json_convert_content.dart';

class PurchaseReceiveEntity with JsonConvert<PurchaseReceiveEntity> {
	int id;
	int purchaseId;
	String images;
	String status;
	String sum;
	int updatetime;
	int createtime;
	String remark;
}
