import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/generated/json/base/json_field.dart';

class UserInfoEntity with JsonConvert<UserInfoEntity> {
	int id;
	String username;
	String nickname;
	String password;
	String salt;
	String email;
	String mobile;
	String avatar;
	String gender;
	String birthday;
	@JSONField(name: "dealer_id")
	int dealerId;
	String bio;
	int money;
	int score;
	int successions;
	int maxsuccessions;
	int prevtime;
	int logintime;
	String loginip;
	int loginfailure;
	String joinip;
	int jointime;
	int createtime;
	int updatetime;
	String token;
	String status;
	String verification;
	@JSONField(name: "id_z_image")
	String idZImage;
	@JSONField(name: "id_f_image")
	String idFImage;
	@JSONField(name: "id_card")
	String idCard;
	@JSONField(name: "if_login_admin")
	String ifLoginAdmin;
	@JSONField(name: "is_del")
	int isDel;
	int auth;
	@JSONField(name: "is_vip")
	int isVip;
	@JSONField(name: "vip_end_time")
	String vipEndTime;
	@JSONField(name: "id_card_date")
	String idCardDate;
	@JSONField(name: "card_type")
	int cardType;
	UserInfoDealer dealer;
	UserInfoDealerApply dealerApply;
}

class UserInfoDealer with JsonConvert<UserInfoDealer> {
	int id;
	String image;
	String name;
	@JSONField(name: "credit_code")
	String creditCode;
	String title;
	@JSONField(name: "tax_num")
	String taxNum;
	String city;
	String address;
	String tele;
	int bankcode;
	String explain;
	@JSONField(name: "bank_name")
	String bankName;
	@JSONField(name: "open_term")
	String openTerm;
	@JSONField(name: "store_images")
	String storeImages;
	@JSONField(name: "legal_image_z")
	String legalImageZ;
	@JSONField(name: "legal_image_f")
	String legalImageF;
	String legal;
	@JSONField(name: "legal_idcard_code")
	String legalIdcardCode;
	@JSONField(name: "legal_Idcard_date")
	String legalIdcardDate;
	@JSONField(name: "type_id")
	int typeId;
	@JSONField(name: "start_time")
	String startTime;
	int createtime;
	int updatetime;
	@JSONField(name: "admin_id")
	int adminId;
	String status;
	String remark;
	String type;
}

class UserInfoDealerApply with JsonConvert<UserInfoDealerApply> {
	int id;
	@JSONField(name: "user_id")
	int userId;
	@JSONField(name: "dealer_id")
	int dealerId;
	int status;
	@JSONField(name: "is_delete")
	int isDelete;
	int createtime;
	int updatetime;
	@JSONField(name: "is_deal")
	int isDeal;
}