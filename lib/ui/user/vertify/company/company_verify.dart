import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/channel/zc.dart';
import 'package:tob/entity/business/dealer_type_list_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/kl_dialog.dart';
import 'package:tob/widget/loading.dart';

class CompanyVerifyPage extends StatefulWidget {
  const CompanyVerifyPage({Key key}) : super(key: key);

  @override
  _CompanyVerifyPageState createState() => _CompanyVerifyPageState();
}

class _CompanyVerifyPageState extends State<CompanyVerifyPage> {
  ///营业执照图片
  String businessLicenseImg;

  ///身份证正面图片
  String idCardZImg;

  ///身份证反面图片
  String idCardFImg;

  ///姓名
  TextEditingController _nameController = new TextEditingController();

  ///身份证号
  TextEditingController _idCardController = new TextEditingController();

  ///经销商名称
  TextEditingController _titleController = new TextEditingController();

  ///统一社会信用代码
  TextEditingController _codeController = new TextEditingController();

  ///营业期限
  TextEditingController _dateController = new TextEditingController();

  ///身份证有效期
  TextEditingController _idCardDateController = new TextEditingController();

  ///按钮是否可点击
  bool btnSure = false;

  ///身份证有效期开始日期
  String _startData = "";

  ///身份证有效期结束日期
  String _endDate = "";

  ///身份证有效期提示
  String _dialogTitle = "请选择身份证有效期";

  int _typeId = 0;
  String _type;
  String _startTime;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData(){
    UserInfoDealer userInfoDealer = UserInfo.getUserInfo()?.dealer;
    if(userInfoDealer != null){
      businessLicenseImg = userInfoDealer.image;
      idCardZImg = userInfoDealer.legalImageZ;
      idCardFImg = userInfoDealer.legalImageF;
      _nameController.text = userInfoDealer.legal;
      _titleController.text = userInfoDealer.title;
      _codeController.text = userInfoDealer.creditCode;
      _idCardController.text = userInfoDealer.legalIdcardCode;
      _idCardDateController.text = userInfoDealer.legalIdcardDate;
      _dateController.text = userInfoDealer.openTerm;
      _typeId = userInfoDealer.typeId;
      _type = userInfoDealer.type;
      _startTime = userInfoDealer.startTime;
      checkBtnSure();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _idCardController.dispose();
    _titleController.dispose();
    _codeController.dispose();
    _dateController.dispose();
    _idCardDateController.dispose();
    Loading.dismiss();
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: blueAppbarTitle(title: "企业认证", elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //  上传执照
              pic(
                  img: businessLicenseImg,
                  text: "请上传",
                  intro: "营业执照",
                  function: () {
                    ImgUpload.upload(func: (value) {
                      Loading.show();
                      Http.getInstance()
                          .imgUpload(value, Config.business)
                          .then((value) {
                        String img = value.fileUrl;
                        Loading.show(status: "正在识别...");
                        Http.getInstance()
                            .ocr(
                                image: img,
                                imgType: Config.business,
                                type: 'front')
                            .then((idCardRes) {
                          businessLicenseImg = img;
                          _titleController.text = idCardRes.data["name"];
                          _codeController.text = idCardRes.data["reg_num"];
                          _nameController.text = idCardRes.data["person"];
                          String endData = "";
                          if (idCardRes.data["valid_period"] != false) {
                            if (idCardRes.data["valid_period"] == "29991231") {
                              endData = "长期";
                            } else {
                              endData = idCardRes.data["valid_period"];
                            }
                          }
                          _startTime = idCardRes.data["establish_date"];
                          _dateController.text =
                              idCardRes.data["establish_date"] + "-" + endData;

                          ///清空身份证
                          idCardZImg = null;
                          idCardFImg = null;
                          _idCardController.text = "";
                          checkBtnSure();
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    });
                  }),
              pic(
                  img: idCardZImg,
                  text: "法人身份证正面",
                  intro: "人面像",
                  function: () {
                    if (_nameController.text.length <= 0 ||
                        businessLicenseImg.length == null ||
                        businessLicenseImg.length <= 0) {
                      Loading.toast(msg: "请先上传营业执照");
                      return;
                    }

                    ImgUpload.upload(func: (value) {
                      Loading.show();
                      Http.getInstance()
                          .imgUpload(value, Config.idCard)
                          .then((value) {
                        String img = value.fileUrl;
                        Loading.show(status: "正在识别...");
                        Http.getInstance()
                            .ocr(
                                image: img,
                                imgType: Config.idCard,
                                type: 'front')
                            .then((idCardRes) {
                          if (idCardRes.data["name"] != _nameController.text) {
                            KlAlert.showAlert(
                                content: "身份证和营业执照上的法人不符合",
                                sureFunc: () {
                                  MyRoute.router.pop(context);
                                });
                            return false;
                          }
                          idCardZImg = img;
                          _idCardController.text = idCardRes.data["num"];


                          checkBtnSure();
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    });
                  }),
              pic(
                  img: idCardFImg,
                  text: "法人身份证反面",
                  intro: "国徽像",
                  function: () {
                    if (_nameController.text.length <= 0 ||
                        businessLicenseImg.length == null ||
                        businessLicenseImg.length <= 0) {
                      Loading.toast(msg: "请先上传营业执照");
                      return;
                    }
                    ImgUpload.upload(func: (value) {
                      Loading.show();
                      Http.getInstance()
                          .imgUpload(value, Config.idCard)
                          .then((value) {
                        String img = value.fileUrl;
                        Loading.show(status: "正在识别...");
                        Http.getInstance()
                            .ocr(
                                image: img,
                                imgType: Config.idCard,
                                type: 'back')
                            .then((idCardRes) {
                          idCardFImg = img;
                          String startDate =
                          idCardRes.data["start_date"].toString();
                          String endData =
                          idCardRes.data["end_date"].toString();
                          _idCardDateController.text = startDate + "-" + endData;
                          checkBtnSure();
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    });
                  }),
              //  信息
              SizedBox(height: 50.w),
              comMessageInfo(
                title: "经销商名称",
                content: "请填写经销商名称",
                controller: _titleController,
              ),
              //类型
              GestureDetector(
                onTap: () {
                  Loading.show();
                  Http.getInstance().dealerTypeList().then((value) {
                    _openModalBottomSheet(data: value);
                  }).whenComplete(() => Loading.dismiss());
                },
                child: Container(
                  height: 71.w,
                  margin: EdgeInsets.only(left: 30.w, right: 30.w),
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
                        child: Text(
                          "类型",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff999999),
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${_type == null ? '请选择类型' : _type}",
                              style: TextStyle(fontSize: 26.sp),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.grey,
                            size: 36.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              comMessageInfo(
                title: "统一社会信用代码",
                content: "请填写统一社会信用代码",
                controller: _codeController,
              ),
              comMessageInfo(
                title: "营业期限",
                content: "请填写营业期限",
                controller: _dateController,
              ),
              comMessageInfo(
                title: "法人姓名",
                content: "请填写法人姓名",
                controller: _nameController,
              ),
              comMessageInfo(
                title: "法人身份证号",
                content: "请填写法人身份证号",
                controller: _idCardController,
              ),
              GestureDetector(
                onTap: (){
                  choseDateType();
                },
                child: comMessageInfo(
                    title: "身份证有效期",
                    content: "请填写身份证有效期",
                    controller: _idCardDateController,
                    readonly: true,
                    onTap: (){
                      choseDateType();
                    }
                ),
              ),
              //  按钮
              SizedBox(height: 31.w),
              eleButton(
                  width: 513.w,
                  height: 80.w,
                  con: "立即认证",
                  circular: 40.w,
                  color: btnSure
                      ? ColorConfig.themeColor
                      : ColorConfig.themeColor[100],
                  func: btnSure
                      ? () {
                          closeBoard(context: context);

                          KlAlert.showAlert(content: "是否确认认证？", sureFunc: (){
                            Loading.show();
                            Http.getInstance()
                                .businessAuth(
                              startTime: _startTime,
                              creditCode: _codeController.text,
                              openTerm: _dateController.text,
                              legalIdCardDate: _idCardDateController.text,
                              legalImageZ: CommonUtil.imgDeal(
                                  imgStr: idCardZImg, type: Config.idCard),
                              legalIdCardCode: _idCardController.text,
                              legal: _nameController.text,
                              legalImageF: CommonUtil.imgDeal(
                                  imgStr: idCardFImg, type: Config.idCard),
                              name: _titleController.text,
                              typeId:_typeId,
                              image: CommonUtil.imgDeal(
                                  imgStr: businessLicenseImg,
                                  type: Config.business),
                            )
                                .then((value) {
                              if (value.data["code"] == 200) {
                                Http.getInstance().getUserInfo().then((userInfo) {
                                  UserInfo.setUserInfo(userInfo);
                                  BlocProvider.of<UserInfoBloc>(context)
                                      .add(UserStateEvent());
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              } else if (value.data["code"] == 501) {
                                tips2(
                                    msg: value.data["msg"],
                                    bid: value.data["data"]["bid"]);
                              } else if (value.data["code"] == 502) {
                                tips(
                                    msg: value.data["msg"],
                                    bid: value.data["data"]["bid"]);
                              } else {
                                showToast("系统错误");
                              }
                            }).whenComplete(() => Loading.dismiss());
                          },cancelFunc: (){
                            Navigator.pop(context);
                          });




                        }
                      : null)
            ],
          ),
        ),
      ),
    );
  }

  //图片
  pic({String img, String text, String intro, Function function}) {
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 32.w, top: 14.w),
      padding:
          EdgeInsets.only(left: 20.w, bottom: 30.w, top: 34.w, right: 72.w),
      height: 259.w,
      decoration: BoxDecoration(
        color: ColorConfig.bgColor,
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (img != null) {
                Navigator.push(
                  context,
                  GradualChangeRoute(
                    PhotoPreview(
                      galleryItems: [img],
                      defaultImage: 0,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 311.w,
              height: 195.w,
              decoration: BoxDecoration(
                color: ColorConfig.themeColor,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: img == null
                  ? Text("")
                  : Stack(
                      children: [
                        Align(
                          child: ExtendedImage.network(img,
                              width: 311.w, height: 195.w, fit: BoxFit.fill),
                        ),
                        Align(
                          child: Container(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            alignment: Alignment.center,
                            child: Text("点击查看大图",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 38.w),
              eleButton(
                  width: 174.w,
                  height: 60.w,
                  con: "点击扫描",
                  circular: 20.w,
                  color: ColorConfig.themeColor,
                  size: 32.sp,
                  func: () {
                    if (function != null) {
                      function();
                    }
                  }),
              Row(
                children: [
                  Text(
                    "$text",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: ColorConfig.themeColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    "$intro",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0xffEA1E14),
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  tips({String msg, int bid}) {
    klDialog(
      widget: Column(
        children: [
          SizedBox(height: 64.w),
          Text(
            '该企业已被他人注册',
            style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
                height: 1),
          ),
          SizedBox(height: 32.w),
          Text(
            "$msg",
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorConfig.themeColor,
                height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              eleButton(
                  width: 150.w,
                  height: 60.w,
                  con: "联系客服",
                  circular: 20.w,
                  size: 24.sp,
                  color: ColorConfig.themeColor,
                  func: () {
                    MyRoute.router.pop(context);
                    ZcChannel.startKf();
                  }),
              SizedBox(width: 72.w),
              eleButton(
                width: 150.w,
                height: 60.w,
                con: "加入企业",
                circular: 20.w,
                size: 24.sp,
                color: ColorConfig.themeColor,
                func: () {
                  KlAlert.showAlert(
                    content: "确认申请加入该企业?",
                    sureFunc: () {
                      Loading.show();
                      Http.getInstance().businessApply(bid: bid).then((value) {
                        MyRoute.router.pop(context);
                        MyRoute.router.pop(context);
                        MyRoute.router.pop(context);
                        navTo(context, "${Routes.verifySuccess}?type=2").then((value){
                          MyRoute.router.pop(context);
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    },
                    cancelFunc: () {
                      MyRoute.router.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  tips2({String msg, int bid}) {
    klDialog(
      widget: Column(
        children: [
          SizedBox(height: 64.w),
          Text(
            '该企业正被他人申请',
            style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
                height: 1),
          ),
          SizedBox(height: 32.w),
          Text(
            "$msg",
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorConfig.themeColor,
                height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              eleButton(
                  width: 150.w,
                  height: 60.w,
                  con: "联系客服",
                  circular: 20.w,
                  size: 24.sp,
                  color: ColorConfig.themeColor,
                  func: () {
                    ZcChannel.startKf();
                    MyRoute.router.pop(context);
                  }),
              SizedBox(width: 72.w),
              eleButton(
                width: 150.w,
                height: 60.w,
                con: "暂不操作",
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
  }

  //公共信息展示
  comMessageInfo(
      {@required String title,
      @required String content,
      TextEditingController controller,
      bool readonly = false,
      Function onTap,
      Function change(value)}) {
    return Container(
      height: 71.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
            color: Color(0xff999999),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 24.sp,
                color: Color(0xff999999),
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Expanded(
            child: comTextField(
                hint: "$content",
                controller: controller,
                readonly: readonly,
                onTap: onTap,
                change: (value) {
                  if (change != null) {
                    change(value);
                  }
                  return;
                }),
          ),
        ],
      ),
    );
  }

  //公共输入框
  comTextField(
      {TextEditingController controller,
      @required String hint,
      TextStyle hintStyle,
        bool readonly = false,
        Function onTap,
      Function change(value)}) {
    return Container(
      padding: EdgeInsets.only(left: 10.w),
      child: TextField(

        controller: controller,
        textAlign: TextAlign.right,
        readOnly: readonly,
        onTap: onTap,
        onChanged: (value) {
          checkBtnSure();
          if (change != null) {
            change(value);
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 30.w),
          hintText: "$hint",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 24.sp,
          ),
        ),
      ),
    );
  }

  //检测按钮是否可点击
  void checkBtnSure() {
    if (_titleController.text.length > 0 &&
        _codeController.text.length > 0 &&
        _dateController.text.length > 0 &&
        _nameController.text.length > 0 &&
        _idCardController.text.length > 0 &&
        _typeId > 0 &&
        _idCardDateController.text.length >= 0) {
      btnSure = true;
    } else {
      btnSure = false;
    }
    setState(() {});
  }

  //打开类型选择
  void _openModalBottomSheet({@required List<DealerTypeListEntity> data}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400.w,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _type = data[index].name;
                    _typeId = data[index].id;
                    checkBtnSure();
                    MyRoute.router.pop(context);
                  });
                },
                child: Container(
                  height: 100.w,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: index == 0 ? 0 : 2.w,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text("${data[index].name}"),
                ),
              );
            },
          ),
        );
      },
    );
  }

  ///有效期方式选择
  choseDateType() {
    ///现将开始日期和结束日期赋值
    String dates = _idCardDateController.text;
    if (dates.length > 0 && dates != "长期有效") {
      _startData = dates.split('-')[0];
      _endDate = dates.split('-')[1];
    } else {
      _startData = "";
      _endDate = "";
    }

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "$_dialogTitle",
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    eleButton(
                        width: 100.w,
                        height: 50.h,
                        con: "长期有效",
                        circular: 10.r,
                        color: ColorConfig.themeColor,
                        func: () {
                          _idCardDateController.text = "长期有效";
                          Navigator.pop(context);
                        }),
                    eleButton(
                        width: 100.w,
                        height: 50.h,
                        con: "选择有效期",
                        circular: 10.r,
                        color: ColorConfig.themeColor,
                        func: () {
                          Navigator.pop(context);
                          showDateSelect();
                        }),
                  ],
                ),
              ),
            ],
          );
        });
  }

  ///选择日期
  void showDateSelect() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return SimpleDialog(
              title: Text(
                "$_dialogTitle",
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          String dates = _idCardDateController.text;
                          PDuration pDuration = PDuration.now();
                          if (dates.length > 0 && dates != "长期有效") {
                            _startData = dates.split('-')[0];
                            if (_startData != null && _startData.length > 0) {
                              int year = int.parse(_startData.substring(0, 4));
                              int month = int.parse(
                                  _startData.toString().substring(4, 6));
                              int day = int.parse(_startData.substring(6, 8));
                              print(year);
                              pDuration = PDuration(
                                year: year,
                                month: month,
                                day: day,
                              );
                            }
                          }
                          comPickerDate((String date) {
                            _startData = date;
                            state(() {});
                          }, pDuration: pDuration);
                        },
                        child: comContainer(
                            title: '开始时间：',
                            widget: Text(
                                "${_startData.length > 0 ? _startData : '请选择开始日期'}")),
                      ),
                      GestureDetector(
                        onTap: () {
                          String dates = _idCardDateController.text;
                          PDuration pDuration = PDuration.now();
                          if (dates.length > 0 && dates != "长期有效") {
                            _endDate = dates.split('-')[1];
                            if (_endDate != null && _endDate.length > 0) {
                              int year = int.parse(_endDate.substring(0, 4));
                              int month = int.parse(
                                  _endDate.toString().substring(4, 6));
                              int day = int.parse(_endDate.substring(6, 8));
                              print(year);
                              pDuration = PDuration(
                                year: year,
                                month: month,
                                day: day,
                              );
                            }
                          }
                          comPickerDate((String date) {
                            _endDate = date;
                            state(() {});
                          }, pDuration: pDuration);
                        },
                        child: comContainer(
                            title: '结束时间：',
                            widget: Text(
                                "${_endDate.length > 0 ? _endDate : '请选择结束日期'}")),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    eleButton(
                        width: 100.w,
                        height: 50.h,
                        con: "取消",
                        circular: 10.r,
                        color: ColorConfig.cancelColor,
                        func: () {
                          Navigator.pop(context);
                        }),
                    eleButton(
                        width: 100.w,
                        height: 50.h,
                        con: "确认",
                        circular: 10.r,
                        color: ColorConfig.themeColor,
                        func: () {
                          if(_startData==null ||  _startData.length<=0){
                            Loading.toast(msg: "请选择开始时间");
                            return;
                          }
                          if(_endDate==null ||  _endDate.length<=0){
                            Loading.toast(msg: "请选择结束时间");
                            return;
                          }
                          _idCardDateController.text =
                              _startData + '-' + _endDate;
                          setState(() {});
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ],
            );
          });
        });
  }

  ///封装公共选择日期
  comPickerDate(Function func, {PDuration pDuration}) {
    Pickers.showDatePicker(
      context,
      // 模式，详见下方
      mode: DateMode.YMD,
      selectDate: pDuration != null ? pDuration : PDuration.now(),
      onConfirm: (p) {
        int month = p.month;
        String monthStr = month.toString();
        if (month < 10) {
          monthStr = "0" + monthStr;
        }

        int day = p.day;
        String dayStr = day.toString();
        if (day < 10) {
          dayStr = "0" + dayStr;
        }
        String date = p.year.toString() + monthStr + dayStr;
        if (func != null) {
          func(date);
        }
      },
    );
  }

  comContainer({@required String title, @required Widget widget}) {
    return Container(
      height: 71.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
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
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 24.sp,
                color: Color(0xff999999),
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          widget,
        ],
      ),
    );
  }
}
