import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetAuth extends StatefulWidget {
  const GetAuth({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  GetAccessToken createState() => GetAccessToken();
}

class DataStorage {
  static const _storage = FlutterSecureStorage();

  static Future setData(key, val) async =>
      await _storage.write(key: key, value: val);

  static Future getData(key) async => await _storage.read(key: key);
  static Future delData(key) async => await _storage.delete(key: key);
}

class GetAccessToken extends State<GetAuth> {
  final String _clientId = "DBTrc5BBR5xKhm6_lQ_I9A";
  final String _tokenUrl = "https://www.reddit.com/api/v1/access_token";
  final String _codeUrl = "https://www.reddit.com/api/v1/authorize.compact?";
  final String _redirectUrl = "http://localhost:8080/";

  final _webView = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    String url = _codeUrl +
        "client_id=$_clientId&response_type=code&state=randrand&redirect_uri=$_redirectUrl&scope=*";
    return WebviewScaffold(
      url: url,
      withJavascript: true,
      headers: const {
        'User-Agent': 'random',
        'Access-Control-Allow-Origin': '*',
      },
    );
  }

  @override
  void dispose() {
    _webView.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _webView.close();
    _webView.onDestroy.listen((_) {});

    _webView.onStateChanged.listen((event) async {
      if (event.type == WebViewState.finishLoad) {
        _webView.evalJavascript("document.documentElement.innerText");
      }
    });

    _webView.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          var uri = Uri.parse(url);
          var api = Uri.parse(_tokenUrl);

          uri.queryParameters.forEach((key, value) async {
            if (key == "code") {
              String password = "";

              var response = await http
                  .post(api, // headers: {"Content-Type": "application/json"},
                      headers: <String, String>{
                    'authorization': "Basic " +
                        base64Encode(utf8.encode("$_clientId:$password"))
                  }, body: {
                "grant_type": "authorization_code",
                "code": value,
                "redirect_uri": _redirectUrl,
              });

              Map<String, dynamic> body = jsonDecode(response.body);
              await DataStorage.setData("access_token", body["access_token"]);

              print("token = " + body["access_token"]);

              _webView.close();
              _webView.dispose();

              Navigator.pushNamed(context, '/home');
            }
          });
        });
      }
    });
  }
}
