import 'dart:convert';

import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/network_data.dart';
import 'package:weather_app/services/weather_model.dart';

const weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';
const weatherForecastApiUrl = 'https://api.openweathermap.org/data/2.5/onecall';

class Weather {
  
  Future<WeatherModel> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkData networkHelper = NetworkData(
        '$weatherApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=${location.apiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    WeatherModel weatherModel = WeatherModel.fromJson(weatherData);
    return weatherModel;
  }

  Future<dynamic> getLocationWeatherForecast() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkData networkHelper = NetworkData(
        '$weatherForecastApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=${location.apiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getCityWeather(String cityName) async {
    Location location = Location();
    var url =
        '$weatherApiUrl?q=$cityName&appid=${location.apiKey}&units=metric';
    NetworkData networkHelper = NetworkData(url);
    var weatherData = networkHelper.getData();
    // print(weatherData);
    return weatherData;
  }

  Future<dynamic> getCityWeatherForecast(String cityName) async {
    Location location = Location();
    await location.getLocationDetails(cityName);
    var url =
        '$weatherForecastApiUrl?lat=${location.latitude}&lon=${location.longitide}&appid=${location.apiKey}&units=metric';
    NetworkData networkHelper = NetworkData(url);
    var weatherData = await networkHelper.getData();
    // print(weatherData);
    return weatherData;
  }
}
