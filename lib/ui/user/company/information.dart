import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tob/entity/company_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/widget/image_show.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  CompanyEntity _companyEntity = new CompanyEntity();
  TextStyle style = TextStyle(
    fontSize: 28.sp,
    color: Color(0xff242E42),
  );

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Http.getInstance().getCompany().then((value) {
      setState(() {
        _companyEntity = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_companyEntity?.id == null) {
      return Scaffold(
        appBar: commonAppbarTitle(title: '企业信息'),
        body: loadingData(),
      );
    }

    return Scaffold(
      appBar: commonAppbarTitle(title: '企业信息'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 88.w,
                decoration: BoxDecoration(
                  color: ColorConfig.themeColor,
                ),
              ),
              info(),
            ],
          ),
        ),
      ),
    );
  }

  info() {
    return Transform.translate(
        offset: Offset(0, -48.w),
        child: Column(
          children: [
            //企业信息照片
            Container(
              width: 688.w,
              padding: EdgeInsets.only(
                  top: 48.w, left: 40.w, right: 54.w, bottom: 30.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      offset: Offset(0, 6.w),
                      blurRadius: 20.w,
                      spreadRadius: 0.w),
                ],
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('公司全称', style: style),
                      Text('${_companyEntity.name}', style: style),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('统一社会信用代码', style: style),
                      Text('${_companyEntity.creditCode}', style: style),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        GradualChangeRoute(PhotoPreview(
                          galleryItems: [_companyEntity.image],
                          defaultImage: 0,
                        )),
                      );
                    },
                    child: Container(
                      width: 502.w,
                      height: 308.w,
                      margin: EdgeInsets.only(top: 66.w, bottom: 30.w),
                      child: ExtendedImage.network(
                        '${_companyEntity.image}',
                        width: 502.w,
                        height: 308.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text('营业执照', style: style),
                ],
              ),
            ),
            //其他企业信息
            Container(
              width: 688.w,
              margin: EdgeInsets.only(top: 44.w),
              padding: EdgeInsets.only(
                  top: 40.w, left: 40.w, right: 54.w, bottom: 30.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      offset: Offset(0, 6.w),
                      blurRadius: 20.w,
                      spreadRadius: 0.w),
                ],
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('开票信息', style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                      ),),
                      // Text('${_companyEntity.name}', style: style),
                    ],
                  ),
                  sizedBox('名称', '${_companyEntity.title}'),
                  sizedBox('税号', '${_companyEntity.taxNum}'),
                  sizedBox('单位城市', '${_companyEntity.city}'),
                  sizedBox('详细地址', '${_companyEntity.address}'),
                  sizedBox('电话号码', '${_companyEntity.tele}'),
                  sizedBox('银行账户', '${_companyEntity.bankcode}'),
                ],
              ),
            ),
          ],
        ));
  }

  SizedBox sizedBox(String title, String content) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title', style: style),
          Container(
            width: 400.w,
            alignment: Alignment.centerRight,
            child: Text('$content', style: style),
          ),
        ],
      ),
    );
  }
}
