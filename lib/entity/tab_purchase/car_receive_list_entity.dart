import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class CarReceiveListEntity with JsonConvert<CarReceiveListEntity> {
	int count;
	@JSONField(name: "list")
	List<CarReceiveListList> xList;
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

class CarReceiveListList with JsonConvert<CarReceiveListList> {
	int id;
	int carOrderId;
	String images;
	String status;
	String sum;
	int updatetime;
	String createtime;
	String remark;
}
