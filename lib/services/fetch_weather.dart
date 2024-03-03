import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:weatherapp/constants/api_key.dart';
import 'package:weatherapp/models/weather_model.dart';

class FetchWeather {
  Future<WeatherModel> fetchWeather(String city) async {
    try {
      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
          {'q': city, "units": "metric", "appid": apiKey});

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        print(decodedJson);
        return WeatherModel.fromMap(decodedJson);
      } else {
        // Log the status code and response body for debugging
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load weather data with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data because of $e');
    }
  }
}
