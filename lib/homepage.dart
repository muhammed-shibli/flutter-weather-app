import 'dart:async';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:weather_app/services/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather_provider.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  // final weatherData;
  // final weatherForecastData;
  HomePage({super.key});

  // int? temperature;
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Weather weatherModel = Weather();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  // BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    weatherProvider.createBottomBannerAd();

    return Scaffold(
      bottomNavigationBar: weatherProvider.isBottomBannerAdLoaded
          ? Container(
              height: weatherProvider.bottomBannerAd.size.height.toDouble(),
              width: weatherProvider.bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: weatherProvider.bottomBannerAd),
            )
          : null,
        appBar: AppBarWithSearchSwitch(
          fieldHintText: 'Search Location..',
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[700],
          appBarBuilder: (context) {
            return AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset('assets/icons/man.png'),
              ),
              title:
                  Text("Weather App", style: GoogleFonts.poppins(fontSize: 20)),
              centerTitle: true,
              actions: [
                AppBarSearchButton(
                  searchActiveButtonColor: Colors.blueAccent,
                )
              ],
            );
          },
          onChanged: (value) {
            weatherProvider.updateCity(value);
          },
          onSubmitted: (value) async {
            if (weatherProvider.cityUpdate != null) {
              weatherProvider.changeIsLoading(true);

              var weatherData1 = await weatherModel
                  .getCityWeather(weatherProvider.cityUpdate!);
              var weatherForecastData1 = await weatherModel
                  .getCityWeatherForecast(weatherProvider.cityUpdate!);

              weatherProvider.getMainLocationData(
                  weatherData1, weatherForecastData1);
              _controller.add(SwipeRefreshState.hidden);

              weatherProvider.changeIsLoading(false);
            }
          },
        ),
        body: SwipeRefresh.material(
            stateStream: _stream,
            onRefresh: () async {
              weatherProvider.changeIsLoading(false);
              var weatherData = await weatherModel.getLocationWeather();
              var weatherForecastData =
                  await weatherModel.getLocationWeatherForecast();
              weatherProvider.getMainLocationData(
                  weatherData, weatherForecastData);
              _controller.sink.add(SwipeRefreshState.hidden);
            },
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // // TODO: Load a banner ad
                      // if (weatherProvider.isBannerAdReady)
                      //   Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Container(
                      //       width:
                      //           weatherProvider.b  annerAd.size.width.toDouble(),
                      //       height:
                      //           weatherProvider.bannerAd.size.height.toDouble(),
                      //       child: AdWidget(ad: weatherProvider.bannerAd),
                      //     ),
                      //   ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/placeholder.png',
                            height: 25,
                          ),
                          weatherProvider.country == null
                              ? Text(
                                  ' ${weatherProvider.city}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                )
                              : Text(
                                  ' ${weatherProvider.city},${weatherProvider.country}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                ),
                        ],
                      ),
                      Text(
                          '  ${DateFormat('dd MMMM,EEEE yyyy ').format(DateTime.now())}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 50),
                      Center(
                          child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(200),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(48, 158, 158, 158),
                                  blurRadius: 100,
                                  offset: Offset(30, 40)),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/weather/${weatherProvider.condition}.png',
                              width: 125,
                              height: 125,
                            ),
                            weatherProvider.isLoading
                                ? CircularProgressIndicator()
                                : Text("${weatherProvider.temperature}\u00B0",
                                    style: GoogleFonts.poppins(
                                        fontSize: 40,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w600)),
                            Text("${weatherProvider.description}",
                                style: GoogleFonts.poppins(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                          ],
                        ),
                      )),
                      SizedBox(height: 50),
                      Text(
                        "Next 24 hours",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 24,
                          itemBuilder: (context, index) {
                            var forecastData = weatherProvider
                                .weatherForecastData['hourly'][index];
                            if (DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            forecastData['dt'] * 1000)
                                        .toString())) ==
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())) {
                              weatherProvider.setDay("today");
                            } else {
                              weatherProvider.setDay("tomorrow");
                            }

                            return Container(
                              width: 105,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(82, 158, 158, 158)),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Column(children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(69, 186, 217, 243),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset(
                                    'assets/icons/weather/${forecastData['weather'][0]['main']}.png',
                                  ),
                                ),
                                Text("${forecastData['temp'].toInt()}\u00B0",
                                    style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w600)),
                                Flexible(
                                  child: Text(
                                    '${DateFormat('hh:mm a,').format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(forecastData['dt'] * 1000).toString())).toString()} ${weatherProvider.day}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Next 7 Days",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: 7,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var forecastData = weatherProvider
                              .weatherForecastData['daily'][index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(82, 158, 158, 158)),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(69, 186, 217, 243),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Image.asset(
                                    'assets/icons/weather/${forecastData['weather'][0]['main']}.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "${forecastData['temp']['day'].toInt()}\u00B0",
                                    style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat('dd-MM-yyy')
                                      .format(DateTime.parse(
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  forecastData['dt'] * 1000)
                                              .toString()))
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                ),
                              ]),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ]));
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
