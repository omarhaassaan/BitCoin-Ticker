import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkingAdapter {
  final String _url;
  NetworkingAdapter(this._url);

  Future getData() async {
    String key = 'MThjYTk2NzJjMmU4NDM0NzlhMmU4ODY4OWVlYWQ5NTk';
//    <'x-ba-key',key>
    Map<String, String> userHeader = {"x-ba-key": key};
    http.Response r = await http.get(
      this._url,
      headers: userHeader,
    );
    if (r.statusCode == 200) print("Successfull Resquest");
    return jsonDecode(r.body);
  }
}
