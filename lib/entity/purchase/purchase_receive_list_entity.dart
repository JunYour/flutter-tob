import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class PurchaseReceiveListEntity with JsonConvert<PurchaseReceiveListEntity> {
	int count;
	@JSONField(name: "list")
	List<PurchaseReceiveListList> xList;
	int page;
	int perPage;
	int pageCount;
	@JSONField(name: "al_receiv")
	int alReceiv;
	@JSONField(name: "sh_receiv")
	int shReceiv;
	@JSONField(name: "can_receiv")
	int canReceiv;
}

class PurchaseReceiveListList with JsonConvert<PurchaseReceiveListList> {
	int id;
	int purchaseId;
	String images;
	String status;
	String sum;
	int updatetime;
	String createtime;
	String remark;
}
