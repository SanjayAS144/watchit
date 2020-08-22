import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  Future getData() async {
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        print('ERROR: ${response.statusCode}');
      }
    } catch (error) {
      throw error;
    }
  }
}
