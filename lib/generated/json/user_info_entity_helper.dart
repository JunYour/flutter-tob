import 'package:tob/entity/user_info_entity.dart';

userInfoEntityFromJson(UserInfoEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['username'] != null) {
		data.username = json['username'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['password'] != null) {
		data.password = json['password'].toString();
	}
	if (json['salt'] != null) {
		data.salt = json['salt'].toString();
	}
	if (json['email'] != null) {
		data.email = json['email'].toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['birthday'] != null) {
		data.birthday = json['birthday'].toString();
	}
	if (json['dealer_id'] != null) {
		data.dealerId = json['dealer_id'] is String
				? int.tryParse(json['dealer_id'])
				: json['dealer_id'].toInt();
	}
	if (json['bio'] != null) {
		data.bio = json['bio'].toString();
	}
	if (json['money'] != null) {
		data.money = json['money'] is String
				? int.tryParse(json['money'])
				: json['money'].toInt();
	}
	if (json['score'] != null) {
		data.score = json['score'] is String
				? int.tryParse(json['score'])
				: json['score'].toInt();
	}
	if (json['successions'] != null) {
		data.successions = json['successions'] is String
				? int.tryParse(json['successions'])
				: json['successions'].toInt();
	}
	if (json['maxsuccessions'] != null) {
		data.maxsuccessions = json['maxsuccessions'] is String
				? int.tryParse(json['maxsuccessions'])
				: json['maxsuccessions'].toInt();
	}
	if (json['prevtime'] != null) {
		data.prevtime = json['prevtime'] is String
				? int.tryParse(json['prevtime'])
				: json['prevtime'].toInt();
	}
	if (json['logintime'] != null) {
		data.logintime = json['logintime'] is String
				? int.tryParse(json['logintime'])
				: json['logintime'].toInt();
	}
	if (json['loginip'] != null) {
		data.loginip = json['loginip'].toString();
	}
	if (json['loginfailure'] != null) {
		data.loginfailure = json['loginfailure'] is String
				? int.tryParse(json['loginfailure'])
				: json['loginfailure'].toInt();
	}
	if (json['joinip'] != null) {
		data.joinip = json['joinip'].toString();
	}
	if (json['jointime'] != null) {
		data.jointime = json['jointime'] is String
				? int.tryParse(json['jointime'])
				: json['jointime'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['verification'] != null) {
		data.verification = json['verification'].toString();
	}
	if (json['id_z_image'] != null) {
		data.idZImage = json['id_z_image'].toString();
	}
	if (json['id_f_image'] != null) {
		data.idFImage = json['id_f_image'].toString();
	}
	if (json['id_card'] != null) {
		data.idCard = json['id_card'].toString();
	}
	if (json['if_login_admin'] != null) {
		data.ifLoginAdmin = json['if_login_admin'].toString();
	}
	if (json['is_del'] != null) {
		data.isDel = json['is_del'] is String
				? int.tryParse(json['is_del'])
				: json['is_del'].toInt();
	}
	if (json['auth'] != null) {
		data.auth = json['auth'] is String
				? int.tryParse(json['auth'])
				: json['auth'].toInt();
	}
	if (json['is_vip'] != null) {
		data.isVip = json['is_vip'] is String
				? int.tryParse(json['is_vip'])
				: json['is_vip'].toInt();
	}
	if (json['vip_end_time'] != null) {
		data.vipEndTime = json['vip_end_time'].toString();
	}
	if (json['id_card_date'] != null) {
		data.idCardDate = json['id_card_date'].toString();
	}
	if (json['card_type'] != null) {
		data.cardType = json['card_type'] is String
				? int.tryParse(json['card_type'])
				: json['card_type'].toInt();
	}
	if (json['dealer'] != null) {
		data.dealer = UserInfoDealer().fromJson(json['dealer']);
	}
	if (json['dealerApply'] != null) {
		data.dealerApply = UserInfoDealerApply().fromJson(json['dealerApply']);
	}
	return data;
}

Map<String, dynamic> userInfoEntityToJson(UserInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['password'] = entity.password;
	data['salt'] = entity.salt;
	data['email'] = entity.email;
	data['mobile'] = entity.mobile;
	data['avatar'] = entity.avatar;
	data['gender'] = entity.gender;
	data['birthday'] = entity.birthday;
	data['dealer_id'] = entity.dealerId;
	data['bio'] = entity.bio;
	data['money'] = entity.money;
	data['score'] = entity.score;
	data['successions'] = entity.successions;
	data['maxsuccessions'] = entity.maxsuccessions;
	data['prevtime'] = entity.prevtime;
	data['logintime'] = entity.logintime;
	data['loginip'] = entity.loginip;
	data['loginfailure'] = entity.loginfailure;
	data['joinip'] = entity.joinip;
	data['jointime'] = entity.jointime;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['token'] = entity.token;
	data['status'] = entity.status;
	data['verification'] = entity.verification;
	data['id_z_image'] = entity.idZImage;
	data['id_f_image'] = entity.idFImage;
	data['id_card'] = entity.idCard;
	data['if_login_admin'] = entity.ifLoginAdmin;
	data['is_del'] = entity.isDel;
	data['auth'] = entity.auth;
	data['is_vip'] = entity.isVip;
	data['vip_end_time'] = entity.vipEndTime;
	data['id_card_date'] = entity.idCardDate;
	data['card_type'] = entity.cardType;
	data['dealer'] = entity.dealer?.toJson();
	data['dealerApply'] = entity.dealerApply?.toJson();
	return data;
}

userInfoDealerFromJson(UserInfoDealer data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['credit_code'] != null) {
		data.creditCode = json['credit_code'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['tax_num'] != null) {
		data.taxNum = json['tax_num'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['address'] != null) {
		data.address = json['address'].toString();
	}
	if (json['tele'] != null) {
		data.tele = json['tele'].toString();
	}
	if (json['bankcode'] != null) {
		data.bankcode = json['bankcode'] is String
				? int.tryParse(json['bankcode'])
				: json['bankcode'].toInt();
	}
	if (json['explain'] != null) {
		data.explain = json['explain'].toString();
	}
	if (json['bank_name'] != null) {
		data.bankName = json['bank_name'].toString();
	}
	if (json['open_term'] != null) {
		data.openTerm = json['open_term'].toString();
	}
	if (json['store_images'] != null) {
		data.storeImages = json['store_images'].toString();
	}
	if (json['legal_image_z'] != null) {
		data.legalImageZ = json['legal_image_z'].toString();
	}
	if (json['legal_image_f'] != null) {
		data.legalImageF = json['legal_image_f'].toString();
	}
	if (json['legal'] != null) {
		data.legal = json['legal'].toString();
	}
	if (json['legal_idcard_code'] != null) {
		data.legalIdcardCode = json['legal_idcard_code'].toString();
	}
	if (json['legal_Idcard_date'] != null) {
		data.legalIdcardDate = json['legal_Idcard_date'].toString();
	}
	if (json['type_id'] != null) {
		data.typeId = json['type_id'] is String
				? int.tryParse(json['type_id'])
				: json['type_id'].toInt();
	}
	if (json['start_time'] != null) {
		data.startTime = json['start_time'].toString();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['admin_id'] != null) {
		data.adminId = json['admin_id'] is String
				? int.tryParse(json['admin_id'])
				: json['admin_id'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['remark'] != null) {
		data.remark = json['remark'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	return data;
}

Map<String, dynamic> userInfoDealerToJson(UserInfoDealer entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['image'] = entity.image;
	data['name'] = entity.name;
	data['credit_code'] = entity.creditCode;
	data['title'] = entity.title;
	data['tax_num'] = entity.taxNum;
	data['city'] = entity.city;
	data['address'] = entity.address;
	data['tele'] = entity.tele;
	data['bankcode'] = entity.bankcode;
	data['explain'] = entity.explain;
	data['bank_name'] = entity.bankName;
	data['open_term'] = entity.openTerm;
	data['store_images'] = entity.storeImages;
	data['legal_image_z'] = entity.legalImageZ;
	data['legal_image_f'] = entity.legalImageF;
	data['legal'] = entity.legal;
	data['legal_idcard_code'] = entity.legalIdcardCode;
	data['legal_Idcard_date'] = entity.legalIdcardDate;
	data['type_id'] = entity.typeId;
	data['start_time'] = entity.startTime;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['admin_id'] = entity.adminId;
	data['status'] = entity.status;
	data['remark'] = entity.remark;
	data['type'] = entity.type;
	return data;
}

userInfoDealerApplyFromJson(UserInfoDealerApply data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? int.tryParse(json['user_id'])
				: json['user_id'].toInt();
	}
	if (json['dealer_id'] != null) {
		data.dealerId = json['dealer_id'] is String
				? int.tryParse(json['dealer_id'])
				: json['dealer_id'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['is_delete'] != null) {
		data.isDelete = json['is_delete'] is String
				? int.tryParse(json['is_delete'])
				: json['is_delete'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'] is String
				? int.tryParse(json['createtime'])
				: json['createtime'].toInt();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['is_deal'] != null) {
		data.isDeal = json['is_deal'] is String
				? int.tryParse(json['is_deal'])
				: json['is_deal'].toInt();
	}
	return data;
}

Map<String, dynamic> userInfoDealerApplyToJson(UserInfoDealerApply entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['user_id'] = entity.userId;
	data['dealer_id'] = entity.dealerId;
	data['status'] = entity.status;
	data['is_delete'] = entity.isDelete;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['is_deal'] = entity.isDeal;
	return data;
}