import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/city.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_dialog.dart';
import 'package:tob/widget/loading.dart';

import '../verify_common.dart';

class CompanyVerifyInfoPage extends StatefulWidget {
  final int bid;

  CompanyVerifyInfoPage({@required this.bid});

  @override
  _CompanyVerifyInfoPageState createState() => _CompanyVerifyInfoPageState();
}

class _CompanyVerifyInfoPageState extends State<CompanyVerifyInfoPage> {
  //  税号
  TextEditingController _dutyController = new TextEditingController();

  //  城市
  TextEditingController _cityController = new TextEditingController();

  //  地址
  TextEditingController _addressController = new TextEditingController();

  //  电话
  TextEditingController _mobileController = new TextEditingController();

  //  银行
  TextEditingController _bankController = new TextEditingController();

  //  账户
  TextEditingController _accountController = new TextEditingController();

  //  时间
  TextEditingController _timeController = new TextEditingController();

  UserInfoDealer _userInfoDealer;

  bool btnSure = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      Http.getInstance().businessInfo(bid: widget.bid).then((value) {
        if (mounted) {
          _userInfoDealer = value;
          if (_userInfoDealer != null) {
            _dutyController.text = _userInfoDealer.taxNum;
            _cityController.text = _userInfoDealer.city;
            _addressController.text = _userInfoDealer.address;
            _mobileController.text = _userInfoDealer.tele;
            _bankController.text = _userInfoDealer.bankName;
            _accountController.text = _userInfoDealer.bankcode.toString();
            _timeController.text = _userInfoDealer.startTime.toString();
          }
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dutyController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: blueAppbarTitle(
          title: "企业认证",
          actions: [
            if (_userInfoDealer?.status == "2" &&
                _userInfoDealer.id == UserInfo.getUserInfo().dealerId &&
                UserInfo.getUserInfo().ifLoginAdmin == "2")
              InkWell(
                onTap: () {
                  closeBoard(context: context);
                  klDialog(
                    widget: Column(
                      children: [
                        SizedBox(height: 57.w),
                        Text(
                          '确认重新认证?',
                          style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff333333),
                              height: 1),
                        ),
                        SizedBox(height: 22.w),
                        Container(
                          width: 279.w,
                          child: Text(
                            "一旦提交，将无法查看使用该企业认证的相关功能与数据！",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffE31F15),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            eleButton(
                              width: 150.w,
                              height: 60.w,
                              con: "是",
                              circular: 20.w,
                              size: 24.sp,
                              color: ColorConfig.themeColor,
                              func: () {
                                MyRoute.router.pop(context);
                                Loading.show();
                                 Http.getInstance().staffList(page: 1, limit: 2, bid: widget.bid).then((value){
                                  if(value.xList.length>1){
                                    showCleanStaffDialog();
                                  }else{
                                    navTo(context, Routes.reVerify);
                                  }
                                }).whenComplete(() => Loading.dismiss());
                              },
                            ),
                            SizedBox(width: 72.w),
                            eleButton(
                              width: 150.w,
                              height: 60.w,
                              con: "否",
                              circular: 20.w,
                              size: 24.sp,
                              color: ColorConfig.themeColor,
                              func: () {
                                MyRoute.router.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 43.w, right: 43.w),
                  child: Text(
                    "重新认证",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: _userInfoDealer != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    //  企业认证中心
                    word(),
                    //  证件信息
                    info(),
                    //提交
                    if (_userInfoDealer.status == "2" &&
                        _userInfoDealer.id == UserInfo.getUserInfo().dealerId &&
                        UserInfo.getUserInfo().ifLoginAdmin == "2")
                      btn(),
                  ],
                ),
              )
            : loadingData(),
      ),
    );
  }

  word() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30.w, top: 45.w, bottom: 20.w),
      child: Text(
        "企业认证中心",
        style: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.bold,
          color: ColorConfig.themeColor,
          height: 1,
        ),
      ),
    );
  }

  info() {
    return Column(
      children: [
        //证件信息文字
        cardInfo(),
        //信息列表
        messageInfo(title: "经销商名称", content: "${_userInfoDealer?.name ?? ''}"),
        messageInfo(title: "经销商类型", content: "${_userInfoDealer?.type ?? ''}"),
        messageInfo(
            title: "统一社会信用代码", content: "${_userInfoDealer?.creditCode ?? ''}"),
        messageInfo(title: "抬头名称", content: "${_userInfoDealer?.title ?? ''}"),
        messageInfo(title: "法人", content: "${_userInfoDealer?.legal ?? ''}"),
        messageInfo(
            title: "法人身份证号",
            content: "${_userInfoDealer?.legalIdcardCode ?? ''}"),
        //其他信息
        SizedBox(height: 70.w),
        otherInfo(),
      ],
    );
  }

  cardInfo() {
    return Container(
      height: 40.w,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
            color: Color(0xff999999),
          ),
        ),
      ),
      child: Text(
        "证件信息",
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          height: 1,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  otherInfo() {
    return Column(
      children: [
        oInfo(
          title: "税号",
          thisWight: input(controller: _dutyController),
        ),
        oInfo(
          title: "单位城市",
          thisWight: input(controller: _cityController,readOnly: true,onTap: (){
            cityChose(
                context: context,
                func: (area) {
                  _cityController.text = area;
                  btnSure = true;
                  setState(() {
                    
                  });
                });
          }),
        ),
        oInfo(
          title: "详细地址",
          thisWight: input(controller: _addressController),
        ),
        oInfo(
          title: "电话号码",
          thisWight: input(controller: _mobileController),
        ),
        oInfo(
          title: "开户银行",
          thisWight: input(controller: _bankController),
        ),
        oInfo(
          title: "银行账号",
          thisWight: input(controller: _accountController),
        ),
        oInfo(
          title: "成立时间",
          thisWight: input(controller: _timeController,last: true),
        ),
      ],
    );
  }

  oInfo({@required Widget thisWight, @required String title}) {
    return Container(
      height: 71.w,
      margin: EdgeInsets.only(left: 34.w, right: 30.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
            color: Color(0xff999999),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200.w,
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 32.sp,
                color: Color(0xff333333),
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          thisWight,
        ],
      ),
    );
  }

  input({@required TextEditingController controller,bool last=false,bool readOnly=false,Function onTap}) {
    return Row(
      children: [
        Container(
          width: 400.w,
          child: TextField(

            style: TextStyle(
              fontSize: 30.sp,
            ),
            textAlign: TextAlign.right,

            controller:controller,
            readOnly: _userInfoDealer.status == "2" &&
                    _userInfoDealer.id == UserInfo.getUserInfo().dealerId &&
                    UserInfo.getUserInfo().ifLoginAdmin == "2"
                ? readOnly
                : true,
            onChanged: (value) {
              btnSure = true;
              setState(() {});
            },
            onTap: onTap,
            textInputAction: last?TextInputAction.done:TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 0,
                left: 0,
                right: 30.w,
                bottom: 25.w,
              ),
              hintText: "待完善",
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 24.sp,
                color: Color(0xff999999),
              ),
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          size: 35.w,
          color: Color(0xff999999),
        )
      ],
    );
  }

  btn() {
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      child: eleButton(
          width: 500.w,
          height: 70.w,
          con: "提交",
          circular: 35.w,
          color: btnSure ? ColorConfig.themeColor : ColorConfig.themeColor[100],
          func: btnSure
              ? () {
                  closeBoard(context: context);
                  Loading.show();
                  Http.getInstance()
                      .businessUpdate(
                          bid: _userInfoDealer.id,
                          taxNum: _dutyController.text,
                          city: _cityController.text,
                          address: _addressController.text,
                          tele: _mobileController.text,
                          bankName: _bankController.text,
                          bankCode: _accountController.text,
                          startTime: _timeController.text)
                      .then((value) {
                    Loading.toast(msg: "提交成功");
                    setState(() {
                      btnSure = false;
                    });
                  }).whenComplete(() => Loading.dismiss());
                }
              : null),
    );
  }

  showCleanStaffDialog(){
    klDialog(
      height: 350.w,
      widget: Column(
        children: [
          Container(
            height: 163.w,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    iconSize: 50.w,
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.cancel,
                      color: ColorConfig.themeColor,
                    ),
                    onPressed: () {
                      MyRoute.router.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 86.w,
                  left: 170.w,
                  child: Text(
                    '操作提示',
                    style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                        height: 1),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 22.w),
          Container(
            width: 279.w,
            child: Text(
              "重新认证企业需清退全部员工",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE31F15),
                  height: 1),
            ),
          ),
          SizedBox(height: 20.w),
          eleButton(
              width: 200.w,
              height: 50.w,
              con: "确认",
              circular: 25.w,
              color: ColorConfig.themeColor,
              func: () {
                MyRoute.router.pop(context);
              })
        ],
      ),
    );
  }
}
