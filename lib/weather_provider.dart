import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/ad_helper.dart';
import 'package:weather_app/homepage.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/services/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  late BannerAd bottomBannerAd;
   bool isBottomBannerAdLoaded = false;
   createBottomBannerAd() {
    bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
         
            isBottomBannerAdLoaded = true;
        
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    bottomBannerAd.load();
  }

  bool isInternetOn = true;
  int? temperature;
  String? condition;
  int? humidity;
  String? country;
  String? city;
  String? description;
  String? day;
  var weatherForecastData = {};
  bool isLoading = false;
  String? cityUpdate;
  WeatherModel? weatherData;

  Future<void> requestLocationPermission(context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      var status = await Permission.location.status;
      if (status.isPermanentlyDenied) {
        await Geolocator.openLocationSettings();
      } else {
        await Permission.location.request();
      }
      await getLocationData(context);
    }
    isInternetOn = result;
    notifyListeners();
  }

  changeIsInternetOn(value) {
    isInternetOn = value;
    notifyListeners();
  }

  getLocationData(context) async {
   weatherData = await Weather().getLocationWeather();

    weatherForecastData = await Weather().getLocationWeatherForecast();
    getMainLocationData(weatherData, weatherForecastData);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    notifyListeners();
  }

  getMainLocationData(weatherData, weatherForecastData) {
  
    if (weatherData == null) {
      temperature = 0;
      description = 'Error';
      // tempIcon = 'Unable to get weather data';
      city = '';
      return;
    }
    this.weatherForecastData = weatherForecastData;
    condition = weatherData.condition;
    humidity = weatherData.humidity;
    country = weatherData.country;
    city = weatherData.city;
    description = weatherData.description;
    double temp = weatherData.temperature;
    temperature = temp.toInt();
    notifyListeners();
  }

  updateCity(value) {
    cityUpdate = value;
    notifyListeners();
  }

  changeIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setDay(value) {
    day = value;
    notifyListeners();
  }
}
