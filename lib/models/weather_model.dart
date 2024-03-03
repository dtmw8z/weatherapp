class WeatherModel {
  final String temp;
  final String city;

  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['main']['temp'].toString(),
        city = json['name'];
}
