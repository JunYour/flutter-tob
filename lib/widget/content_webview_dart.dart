import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'common_widget.dart';

///把WebView封装起来，要不用起来太难受了
// ignore: must_be_immutable
class ContentWebView extends StatefulWidget {
  String html;
  String title;

  ContentWebView({this.html, this.title});

  @override
  _ContentWebViewState createState() => _ContentWebViewState();
}

class _ContentWebViewState extends State<ContentWebView> {
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  void loadHTML(String html) async {
    if (html == null) {
      return;
    }
    _webViewController.future.then((value) async {
      String contentBase64 =
          base64Encode(const Utf8Encoder().convert(_wrapHtml(html)));
      await value.loadUrl('data:text/html;charset=utf-8;base64,$contentBase64');
    });
  }

  String _wrapHtml(String html) {
    String htmlWrapper = '''
    <html>
    <head>
    <title>hahaha</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta charset="utf-8">
    </head>
    <style type="text/css">
    img{
        display: block;
        height: auto;
        max-width: 100%;
    }
    </style>
    <body>
    $html
    </body>
    </html>''';
    return htmlWrapper;
  }

  @override
  Widget build(BuildContext context) {
    loadHTML(widget.html);
    if (widget.title != null) {
      return Scaffold(
        appBar: commonAppbarTitle(title: widget.title),
        body: WebView(
          initialUrl: "",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController.complete(webViewController);
          },
          gestureNavigationEnabled: true,
        ),
      );
    } else {
      return WebView(
        initialUrl: "",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController.complete(webViewController);
        },
        gestureNavigationEnabled: true,
      );
    }
  }
}
