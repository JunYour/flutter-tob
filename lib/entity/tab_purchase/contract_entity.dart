import 'package:tob/generated/json/base/json_convert_content.dart';

class ContractEntity with JsonConvert<ContractEntity> {
	ContractContract contract;
	String title;
	String contractUrl;
	ContractMain main;
}

class ContractContract with JsonConvert<ContractContract> {
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

class ContractMain with JsonConvert<ContractMain> {
	String name;
	String phone;
	String address;
}
