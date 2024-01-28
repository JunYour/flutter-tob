import 'package:tob/generated/json/base/json_convert_content.dart';

class CityChoseEntity with JsonConvert<CityChoseEntity> {
	int id;
	int pid;
	String shortname;
	String name;
	String mergename;
	int level;
	String pinyin;
	String code;
	String zip;
	String first;
	String lng;
	String lat;
	List<CityChoseChild> child;
}

class CityChoseChild with JsonConvert<CityChoseChild> {
	int id;
	int pid;
	String shortname;
	String name;
	String mergename;
	int level;
	String pinyin;
	String code;
	String zip;
	String first;
	String lng;
	String lat;
	List<CityChoseChildChild> child;
}

class CityChoseChildChild with JsonConvert<CityChoseChildChild> {
	int id;
	int pid;
	String shortname;
	String name;
	String mergename;
	int level;
	String pinyin;
	String code;
	String zip;
	String first;
	String lng;
	String lat;
}
