import 'package:tob/entity/purchase/purchase_file_entity.dart';

purchaseFileEntityFromJson(PurchaseFileEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['purchase_id'] != null) {
		data.purchaseId = json['purchase_id'] is String
				? int.tryParse(json['purchase_id'])
				: json['purchase_id'].toInt();
	}
	if (json['dealer_id'] != null) {
		data.dealerId = json['dealer_id'] is String
				? int.tryParse(json['dealer_id'])
				: json['dealer_id'].toInt();
	}
	if (json['vin'] != null) {
		data.vin = json['vin'].toString();
	}
	if (json['spec_id'] != null) {
		data.specId = json['spec_id'] is String
				? int.tryParse(json['spec_id'])
				: json['spec_id'].toInt();
	}
	if (json['color_id'] != null) {
		data.colorId = json['color_id'] is String
				? int.tryParse(json['color_id'])
				: json['color_id'].toInt();
	}
	if (json['createtime'] != null) {
		data.createtime = json['createtime'].toString();
	}
	if (json['updatetime'] != null) {
		data.updatetime = json['updatetime'] is String
				? int.tryParse(json['updatetime'])
				: json['updatetime'].toInt();
	}
	if (json['color_name'] != null) {
		data.colorName = json['color_name'].toString();
	}
	if (json['state'] != null) {
		data.state = json['state'] is String
				? int.tryParse(json['state'])
				: json['state'].toInt();
	}
	if (json['vin_id'] != null) {
		data.vinId = json['vin_id'] is String
				? int.tryParse(json['vin_id'])
				: json['vin_id'].toInt();
	}
	if (json['client_name'] != null) {
		data.clientName = json['client_name'].toString();
	}
	if (json['client_mobile'] != null) {
		data.clientMobile = json['client_mobile'].toString();
	}
	if (json['client_mobile_state'] != null) {
		data.clientMobileState = json['client_mobile_state'].toString();
	}
	if (json['client_mobile_remarks'] != null) {
		data.clientMobileRemarks = json['client_mobile_remarks'].toString();
	}
	if (json['license_z_image'] != null) {
		data.licenseZImage = json['license_z_image'].toString();
	}
	if (json['license_f_image'] != null) {
		data.licenseFImage = json['license_f_image'].toString();
	}
	if (json['license_f_state'] != null) {
		data.licenseFState = json['license_f_state'] is String
				? int.tryParse(json['license_f_state'])
				: json['license_f_state'].toInt();
	}
	if (json['license_f_remarks'] != null) {
		data.licenseFRemarks = json['license_f_remarks'].toString();
	}
	if (json['cert_image'] != null) {
		data.certImage = json['cert_image'].toString();
	}
	if (json['cert_state'] != null) {
		data.certState = json['cert_state'].toString();
	}
	if (json['cert_remarks'] != null) {
		data.certRemarks = json['cert_remarks'].toString();
	}
	if (json['invoice_image'] != null) {
		data.invoiceImage = json['invoice_image'].toString();
	}
	if (json['invoice_state'] != null) {
		data.invoiceState = json['invoice_state'].toString();
	}
	if (json['invoice_remarks'] != null) {
		data.invoiceRemarks = json['invoice_remarks'].toString();
	}
	if (json['client_id_z_image'] != null) {
		data.clientIdZImage = json['client_id_z_image'].toString();
	}
	if (json['client_id_f_image'] != null) {
		data.clientIdFImage = json['client_id_f_image'].toString();
	}
	if (json['client_idcode'] != null) {
		data.clientIdcode = json['client_idcode'].toString();
	}
	if (json['certificate_image'] != null) {
		data.certificateImage = json['certificate_image'].toString();
	}
	if (json['certificate_image_state'] != null) {
		data.certificateImageState = json['certificate_image_state'].toString();
	}
	if (json['certificate_image_remarks'] != null) {
		data.certificateImageRemarks = json['certificate_image_remarks'].toString();
	}
	if (json['client_id_z_image_state'] != null) {
		data.clientIdZImageState = json['client_id_z_image_state'].toString();
	}
	if (json['client_id_z_image_remarks'] != null) {
		data.clientIdZImageRemarks = json['client_id_z_image_remarks'].toString();
	}
	if (json['client_id_f_image_state'] != null) {
		data.clientIdFImageState = json['client_id_f_image_state'].toString();
	}
	if (json['client_id_f_image_remarks'] != null) {
		data.clientIdFImageRemarks = json['client_id_f_image_remarks'].toString();
	}
	if (json['examinetime'] != null) {
		data.examinetime = json['examinetime'] is String
				? int.tryParse(json['examinetime'])
				: json['examinetime'].toInt();
	}
	if (json['backmoney_status'] != null) {
		data.backmoneyStatus = json['backmoney_status'].toString();
	}
	if (json['backmoney_time'] != null) {
		data.backmoneyTime = json['backmoney_time'] is String
				? int.tryParse(json['backmoney_time'])
				: json['backmoney_time'].toInt();
	}
	if (json['business_image'] != null) {
		data.businessImage = json['business_image'];
	}
	if (json['business_image_state'] != null) {
		data.businessImageState = json['business_image_state'];
	}
	if (json['business_image_remarks'] != null) {
		data.businessImageRemarks = json['business_image_remarks'];
	}
	if (json['business_name'] != null) {
		data.businessName = json['business_name'];
	}
	if (json['business_mobile'] != null) {
		data.businessMobile = json['business_mobile'];
	}
	if (json['business_code'] != null) {
		data.businessCode = json['business_code'];
	}
	if (json['register_type'] != null) {
		data.registerType = json['register_type'];
	}
	return data;
}

Map<String, dynamic> purchaseFileEntityToJson(PurchaseFileEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['purchase_id'] = entity.purchaseId;
	data['dealer_id'] = entity.dealerId;
	data['vin'] = entity.vin;
	data['spec_id'] = entity.specId;
	data['color_id'] = entity.colorId;
	data['createtime'] = entity.createtime;
	data['updatetime'] = entity.updatetime;
	data['color_name'] = entity.colorName;
	data['state'] = entity.state;
	data['vin_id'] = entity.vinId;
	data['client_name'] = entity.clientName;
	data['client_mobile'] = entity.clientMobile;
	data['client_mobile_state'] = entity.clientMobileState;
	data['client_mobile_remarks'] = entity.clientMobileRemarks;
	data['license_z_image'] = entity.licenseZImage;
	data['license_f_image'] = entity.licenseFImage;
	data['license_f_state'] = entity.licenseFState;
	data['license_f_remarks'] = entity.licenseFRemarks;
	data['cert_image'] = entity.certImage;
	data['cert_state'] = entity.certState;
	data['cert_remarks'] = entity.certRemarks;
	data['invoice_image'] = entity.invoiceImage;
	data['invoice_state'] = entity.invoiceState;
	data['invoice_remarks'] = entity.invoiceRemarks;
	data['client_id_z_image'] = entity.clientIdZImage;
	data['client_id_f_image'] = entity.clientIdFImage;
	data['client_idcode'] = entity.clientIdcode;
	data['certificate_image'] = entity.certificateImage;
	data['certificate_image_state'] = entity.certificateImageState;
	data['certificate_image_remarks'] = entity.certificateImageRemarks;
	data['client_id_z_image_state'] = entity.clientIdZImageState;
	data['client_id_z_image_remarks'] = entity.clientIdZImageRemarks;
	data['client_id_f_image_state'] = entity.clientIdFImageState;
	data['client_id_f_image_remarks'] = entity.clientIdFImageRemarks;
	data['examinetime'] = entity.examinetime;
	data['backmoney_status'] = entity.backmoneyStatus;
	data['backmoney_time'] = entity.backmoneyTime;
	data['business_image'] = entity.businessImage;
	data['business_image_state'] = entity.businessImageState;
	data['business_image_remarks'] = entity.businessImageRemarks;
	data['business_name'] = entity.businessName;
	data['business_mobile'] = entity.businessMobile;
	data['business_code'] = entity.businessCode;
	data['register_type'] = entity.registerType;
	return data;
}