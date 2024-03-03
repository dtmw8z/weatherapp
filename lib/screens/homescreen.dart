import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/fetch_weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<WeatherModel> getData(String city) async {
    return await FetchWeather().fetchWeather(city);
  }

  TextEditingController controller = TextEditingController(text: "");
  Future<WeatherModel>? _future;

  @override
  void initState() {
    super.initState();
    _future = getData("Copenhagen");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
            future: _future ?? Future.value(null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error.toString()} occured',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data as WeatherModel;

                  return Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                setState(() {
                                  _future = getData(controller.text);
                                });
                                FocusScope.of(context)
                                    .unfocus(); // Hide keyboard
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Please enter a city name.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text(data.city),
                          Text("${data.temp} degree C")
                        ],
                      ))
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text("${snapshot.connectionState} occured"),
                );
              }
              return const Center(
                child: Text("Server Timed Out"),
              );
            })
      ],
    );
  }
}

/*FutureBuilder<Map<String, dynamic>>(
            future: weather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var cityName = snapshot.data!['name'];
                var temperature = snapshot.data!['main']['temp'];
                return Text('City: $cityName, Temperature: $temperature');
              } else if (snapshot.hasError) {
                return AlertDialog(content: Text('${snapshot.error}'));
              }
              return const CircularProgressIndicator();
            })* */

