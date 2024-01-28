import 'package:tob/generated/json/base/json_convert_content.dart';

class CarFileImageEntity with JsonConvert<CarFileImageEntity> {
	int id;
	int carId;
	String fieldName;
	String enable;
	int uploadCount;
	int createtime;
	int updatetime;
	CarFileImageChild child;
	String imgs;
}

class CarFileImageChild with JsonConvert<CarFileImageChild> {
	int id;
	int carImageId;
	int vinId;
	String value;
	String status;
	String cause;
	int createtime;
	int updatetime;
}
