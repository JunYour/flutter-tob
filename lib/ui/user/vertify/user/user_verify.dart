import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class UserVerifyPage extends StatefulWidget {
  const UserVerifyPage({Key key}) : super(key: key);

  @override
  _UserVerifyPageState createState() => _UserVerifyPageState();
}

class _UserVerifyPageState extends State<UserVerifyPage> {
  String _idCardImageFront;
  String _idCardImageBack;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  String sex; //性别
  String _startData = ""; //身份证有效期开始日期
  String _endDate = ""; //身份证有效期结束日期
  String _dialogTitle = "请选择身份证有效期";

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _dateController.dispose();
    Loading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: blueAppbarTitle(title: "实名认证", elevation: 0),
      body: GestureDetector(
        onTap: () {
          closeBoard(context: context);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //  正面
              front(),
              //  反面
              back(),
              //  信息展示
              SizedBox(height: 30.w),
              //姓名
              name(),
              //身份证号
              code(),
              //证件有效期
              date(),
              //  按钮
              btn(),
            ],
          ),
        ),
      ),
    );
  }

  ///身份证正面
  front() {
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 32.w, top: 65.w),
      padding:
          EdgeInsets.only(left: 20.w, bottom: 30.w, top: 34.w, right: 72.w),
      height: 259.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 311.w,
            height: 195.w,
            decoration: BoxDecoration(
              color: ColorConfig.themeColor,
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: _idCardImageFront != null && _idCardImageFront.length > 0
                ? ExtendedImage.network(_idCardImageFront,
                    width: 311.w, height: 195.w, fit: BoxFit.fill)
                : Text(""),
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
                          setState(() {
                            _idCardImageFront = img;
                            _nameController.text = idCardRes.data["name"];
                            _codeController.text = idCardRes.data["num"];
                            sex = idCardRes.data["sex"];
                            setState(() {});
                          });
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    });
                  }),
              Row(
                children: [
                  Text(
                    "身份证正面",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: ColorConfig.themeColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    "人像面",
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

  ///身份证背面
  back() {
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 32.w, top: 17.w),
      padding:
          EdgeInsets.only(left: 20.w, bottom: 30.w, top: 34.w, right: 72.w),
      height: 259.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 311.w,
            height: 195.w,
            decoration: BoxDecoration(
              color: ColorConfig.themeColor,
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: _idCardImageBack != null && _idCardImageBack.length > 0
                ? ExtendedImage.network(_idCardImageBack,
                    width: 311.w, height: 195.w, fit: BoxFit.fill)
                : Text(""),
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
                          setState(() {
                            _idCardImageBack = img;
                            String startDate =
                                idCardRes.data["start_date"].toString();
                            String endData =
                                idCardRes.data["end_date"].toString();
                            _dateController.text = startDate + "-" + endData;
                            setState(() {});
                          });
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      }).whenComplete(() {
                        Loading.dismiss();
                      });
                    });
                  }),
              Row(
                children: [
                  Text(
                    "身份证反面",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: ColorConfig.themeColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Text(
                    "国徽面",
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

  ///姓名
  name() {
    return comContainer(
      title: "您的真实姓名",
      widget: Expanded(
        child: comTextField(
          controller: _nameController,
          hint: "请输入您的真实姓名",
          bottom: 35.w,
          change: (value) {
            print(value);
            return;
          },
        ),
      ),
    );
  }

  ///身份证号
  code() {
    return comContainer(
      title: "您的身份证号",
      widget: Expanded(
        child: comTextField(
          controller: _codeController,
          hint: "请输入您的身份证号",
          bottom: 35.w,
          change: (value) {
            print(value);
            return;
          },
        ),
      ),
    );
  }

  ///身份证有效期
  date() {
    return GestureDetector(
      onTap: () {
        choseDateType();
      },
      child: comContainer(
        title: "您的证件有效期",
        widget: Expanded(
          child: comTextField(
            controller: _dateController,
            hint: "请输入证件有效期",
            bottom: 35.w,
            readonly: true,
            change: null,
            onTap: () {
              choseDateType();
            },
          ),
        ),
      ),
    );
  }

  ///有效期方式选择
  choseDateType() {
    ///现将开始日期和结束日期赋值
    String dates = _dateController.text;
    if (dates.length > 0 && dates != "长期有效") {
      _startData = dates.split('-')[0];
      _endDate = dates.split('-')[1];
    }else{
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
                          _dateController.text = "长期有效";
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
                          String dates = _dateController.text;
                          PDuration pDuration = PDuration.now();
                          if (dates.length > 0 && dates != "长期有效") {
                            _startData = dates.split('-')[0];
                            if (_startData != null && _startData.length > 0) {
                              int year = int.parse(_startData.substring(0, 4));
                              int month = int.parse(_startData.toString().substring(4, 6));
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
                          String dates = _dateController.text;
                          PDuration pDuration = PDuration.now();
                          if (dates.length > 0 && dates != "长期有效") {
                            _endDate = dates.split('-')[1];
                            if (_endDate != null && _endDate.length > 0) {
                              int year = int.parse(_endDate.substring(0, 4));
                              int month = int.parse(_endDate.toString().substring(4, 6));
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
                          },pDuration: pDuration);
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
                          _dateController.text = _startData + '-' + _endDate;
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

  ///封装公共输入框
  comTextField(
      {TextEditingController controller,
      @required String hint,
      TextStyle hintStyle,
      @required double bottom,
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
          if (change != null) {
            change(value);
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: bottom),
          hintText: "$hint",
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 24.sp,
          ),
        ),
      ),
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

  btn() {
    return Container(
      margin: EdgeInsets.only(top: 150.w),
      child: eleButton(
          width: 513.w,
          height: 80.w,
          con: "立即认证",
          circular: 40.w,
          color: ColorConfig.themeColor,
          func: () {
            if (_idCardImageFront == null) {
              KlAlert.showAlert(
                  content: "请上传身份证正面",
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }

            if (_idCardImageFront == null) {
              KlAlert.showAlert(
                  content: "请上传身份证反面",
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }

            if (_nameController.text.length == 0 ||
                _codeController.text.length == 0 ||
                _dateController.text.length == 0) {
              KlAlert.showAlert(
                  content: "请将身份证信息补充完整",
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }

            Loading.show();
            Http.getInstance()
                .businessRealName(
                    name: _nameController.text,

                    ///
                    imageZ: CommonUtil.imgDeal(
                        imgStr: _idCardImageFront, type: Config.idCard),
                    imageF: CommonUtil.imgDeal(
                        imgStr: _idCardImageBack, type: Config.idCard),
                    code: _codeController.text,
                    date: _dateController.text,
                    sex: sex)
                .then((value) {
              //认证完成后还需要更新本地用户数据
              Loading.show();
              Http.getInstance().getUserInfo().then((userInfo) {
                UserInfo.setUserInfo(userInfo);
                BlocProvider.of<UserInfoBloc>(context).add(UserStateEvent());
                MyRoute.router.pop(context);
              }).whenComplete(() => Loading.dismiss());
            }).whenComplete(() {
              Loading.dismiss();
            });
          }),
    );
  }
}
