import 'package:flutter/material.dart';
import 'package:notus_to_html_to_notus/notus_to_html_to_notus.dart';
import 'package:zefyrka/zefyrka.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notus to html to notus demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notus_To_Html_To_Notus Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _notusDocument;
  late String htmlDoc;

  @override
  void initState() {
    super.initState();
    _notusDocument = createNotusDoc();
    htmlDoc = createHtmlDoc();
  }

  NotusDocument createNotusDoc() {
    final doc = NotusDocument();
    doc.insert(
      0,
      'This package will help you convert notus document to html format',
    );
    doc.format(0, doc.length, NotusAttribute.h1);
    var prevLength = doc.length;
    doc.insert(
      prevLength - 1,
      'This is strikethrough text',
    );
    doc.format(prevLength - 1, doc.length, NotusAttribute.strikethrough);
    return doc;
  }

  String createHtmlDoc() {
    return '<p><b>Bold</b></p><p><i>Italic</i></p><p><u>Underline</u></p><p><s>Stroke</s></p><p>Link</p>';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notus input: ${_notusDocument.toString()}',
            ),
            Text(
              'Html output: ${NotusToHTML.getHtmlFromNotus(_notusDocument)}',
            ),
            Text(
              'Html input: $htmlDoc',
            ),
            Text(
              'Notus output: ${HtmlToNotus.getNotusFromHtml(htmlDoc).toString()}',
            ),
          ],
        ),
      ),
    );
  }
}
