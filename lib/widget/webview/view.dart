import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

///通用WebView页面
// ignore: must_be_immutable
class WebViewPage extends StatefulWidget {
  String _title;
  String _url;

  WebViewPage({title, @required url}) {
    this._title = title;
    this._url = Uri.decodeComponent(url);
    if (!this._url.startsWith("http") && !this._url.startsWith("https")) {
      this._url = "http://${this._url}";
    }
  }

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String _title;
  Animation<double> animation;
  AnimationController controller;
  double _progress = 0;
  bool _loading = false;

  Future<bool> _onWillPop() async {
    await _controller.future.then((value) async {
      if (await value.canGoBack()) {
        await value.goBack();
      } else {
        Navigator.pop(context);
      }
    });
    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    _title = widget._title;
    controller = new AnimationController(
        duration: const Duration(seconds: 3), vsync: this);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
//      ..addStatusListener((status) {
//        if(status == AnimationStatus.completed){
//          showToast("完成！");
//          setState(() {
//            _loading = false;
//          });
//        }
//      })
      ..addListener(() {
        setState(() {
          _progress = animation.value;
        });
      });
//    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _title == null ? "" : _title,
            style: TextStyle(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget._url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest navigation) {
                Future.delayed(Duration.zero, () {
                  if (mounted) {
                    setState(() {
                      print("navigationDelegate---->");
                      _loading = true;
                      controller.reset();
                      controller.forward();
                    });
                  }
                });
                return NavigationDecision.navigate;
              },
              onPageFinished: (url) {
                if (url.startsWith("com.ganchewang.height")) {
                  return;
                }
                _controller.future.then((controller) {
                  //如果没有传标题进来就用h5自带的标题
                  if (_title == null || _title.isEmpty) {
                    controller.getTitle().then((value) {
                      setState(() {
                        _title = value;
                      });
                    });
                  }
                });

                Future.delayed(Duration(milliseconds: 0), () {
                  if (mounted) {
                    setState(() {
                      print("onPageFinished--->url=$url");
                      _loading = false;
                    });
                  }
                });
              },
              gestureNavigationEnabled: true,
            ),
            Offstage(
              offstage: !_loading,
              child: Container(
                height: 5.w,
                child: LinearProgressIndicator(
                  value: _progress,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.green[500]),
                  backgroundColor: Color(0x00000000),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          if (message != null && message.message != null) {
            print("message.message=${message.message}");
            try {
              var map = jsonDecode(message.message);
              var action = map["action"].toString();
              switch (action) {
                // case "share":
                //   String url = Uri.encodeComponent(map["url"].toString());
                //   String title = Uri.encodeComponent(map["title"].toString());
                //   navTo(context, "${Routes.previewPDF}?url=$url&title=$title");
                //   break;
                // case "refresh":
                // //刷新
                //   String orderId = map['orderId'].toString();
                //   Navigator.pop(context);
                //   context.bloc<OrderListBloc>().add(RefreshOrderListEvent(int.parse(orderId)));
                //   break;
              }
            } catch (error) {
              showToast(error.toString());
            }
          }
        });
  }
}
