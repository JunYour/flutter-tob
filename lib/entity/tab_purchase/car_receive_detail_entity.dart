import 'package:tob/generated/json/base/json_convert_content.dart';

class CarReceiveDetailEntity with JsonConvert<CarReceiveDetailEntity> {
	int id;
	int carOrderId;
	String images;
	String status;
	String sum;
	int updatetime;
	int createtime;
	String remark;
	int enddatetime;
	int lid;
}
