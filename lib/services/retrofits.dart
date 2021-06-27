import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tagline_demo/model/dummy_user_model.dart';

final String URL = "https://api.instantwebtools.net/v1/";

Future<DummyUser1> getUser1(String pageNo) async {
  Uri uri = Uri.parse(URL + "passenger?page=$pageNo&size=10");

  http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    String data = response.body;
    var extractData = jsonDecode(data);

    return DummyUser1.fromJson(extractData);
  }

  return null;
}
