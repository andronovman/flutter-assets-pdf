import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String path = "";

  @override
  void initState() {
    super.initState();
    getFileFromAsset("assets/Privacy_Policy.pdf").then((f) {
      setState(() {
        path = f.path;
      });
    });
  }

  Future<File> getFileFromAsset(String asset) async {
    try{
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/Privacy_Policy.pdf");
      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch(e) {
      throw Exception("Error opening asset file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Builder(
            builder: (context) => Column(
              children: <Widget>[
                  RaisedButton(
                    child: Text("Load pdf"),
                    onPressed: () {
                      if(path != null) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => PdfViewPage(path: path))
                        );
                      }
                    },
                  ),
              ],
            ),
          )
          
        ),
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String path;
  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
  
}

class _PdfViewPageState extends State<PdfViewPage> {

  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My document"),),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {
                
              });
            },
          ),
          !pdfReady ? Center(child: CircularProgressIndicator(),) : Offstage()
        ],
      ),
    );
  }

}
