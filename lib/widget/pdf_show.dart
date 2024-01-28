import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tob/widget/wx_share.dart';

class PdfShowPage extends StatefulWidget {
  final String url;
  final String title;
  PdfShowPage({Key key,@required this.url,@required this.title}) : super(key: key);

  @override
  _PdfShowPageState createState() => _PdfShowPageState();
}

class _PdfShowPageState extends State<PdfShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        brightness: Brightness.dark,
        actions: [
          IconButton(
            onPressed: () {
              if(Platform.isIOS){
                wxShare(url: widget.url,type: 0,title: "${widget.title}.pdf",description: widget.title);
              }else{
                wxShare(url: widget.url,type: 1,title: "${widget.title}.pdf");
              }
            },
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SfPdfViewer.network(widget.url),
    );
  }
}
