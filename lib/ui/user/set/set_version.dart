import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/app.dart';

class SetVersion extends StatefulWidget {
  @override
  _SetVersionState createState() => _SetVersionState();
}

class _SetVersionState extends State<SetVersion> {

  String _version;

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  getVersion() async{
    String version = await App.getVersionName();
    setState(() {
      _version = version;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      "版本$_version",
      style: TextStyle(
        fontSize: 32.sp,
        color: Color(0xFF999999),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
