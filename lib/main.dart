import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:teste/custom_dio.dart';
import 'package:teste/localstorage.dart';
import 'package:teste/token_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalStorageService _storage = LocalStorageService();
  CustomDio customDio;

  @override
  void initState() {
    super.initState();
    customDio = CustomDio(_storage);
  }

  Future<void> testDio(String url) async {
    try {
      final response = await customDio.get(url);
      TokenModel token = TokenModel.fromJson(response.data);
      await _storage.put(LocalStorageService.TOKEN, token.toJson());
      print(response.data);
    } on DioError catch (e) {
      //caso erro 400+
      print(e.response?.data);
    }
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
            RaisedButton(
              onPressed: () => testDio(
                  "https://run.mocky.io/v3/c0cbd196-04f2-4a90-854a-24c8c9e11a09"),
              child: Text('Url1'),
            ),
            RaisedButton(
              onPressed: () => testDio(
                  "https://run.mocky.io/v3/fc9ea680-f896-42ae-936a-3fe124638c64"),
              child: Text('Url2'),
            )
          ],
        ),
      ),
    );
  }
}
