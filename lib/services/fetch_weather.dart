import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weatherapp/constants/api_key.dart';

class FetchWeather {
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      var url = Uri.https('api.openweathermap.org', '/data/2.5/forecast',
          {'q': city, "units": "metric", "appid": apiKey});

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load weather data with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data because of $e');
    }
  }
}
