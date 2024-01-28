import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DiyInAppWebView extends StatefulWidget {
  final String title;
  final String url;

  const DiyInAppWebView({Key key, this.title, this.url}) : super(key: key);

  @override
  _DiyInAppWebViewState createState() => _DiyInAppWebViewState();
}

class _DiyInAppWebViewState extends State<DiyInAppWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: false,
      ));

  PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    initAndroid();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
          // webViewController?.reload();
        }
      },
    );
    super.initState();
  }

  initAndroid() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();

        serviceWorkerController.serviceWorkerClient =
            AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.title.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
            body: info())
        : Scaffold(
            body: info(),
          );
  }

  info() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    // var uri = navigationAction.request.url;
                    //
                    // if (![ "http", "https", "file", "chrome",
                    //   "data", "javascript", "about"].contains(uri.scheme)) {
                    //   if (await canLaunch(url)) {
                    //     // Launch the App
                    //     await launch(
                    //       url,
                    //     );
                    //     // and cancel the request
                    //     return NavigationActionPolicy.CANCEL;
                    //   }
                    // }
                    //
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    print("停止加载");
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    print("加载错误");
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                  onWindowBlur: (controller) {
                    print(controller);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     ElevatedButton(
          //       child: Icon(Icons.arrow_back),
          //       onPressed: () {
          //         webViewController?.goBack();
          //       },
          //     ),
          //     ElevatedButton(
          //       child: Icon(Icons.arrow_forward),
          //       onPressed: () {
          //         webViewController?.goForward();
          //       },
          //     ),
          //     ElevatedButton(
          //       child: Icon(Icons.refresh),
          //       onPressed: () {
          //         webViewController?.reload();
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
