import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/weather_provider.dart';

class Weather extends StatelessWidget {
  const Weather({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    weatherProvider.requestLocationPermission(context);

    return Scaffold(
      body: Center(
          child: weatherProvider.isInternetOn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/sun.gif',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      'Loading...',
                      style: GoogleFonts.poppins(),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/no-internet.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No Internet Connection!!',
                      style: GoogleFonts.poppins(),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                        ),
                        onPressed: () {
                          weatherProvider.changeIsInternetOn(true);

                          weatherProvider.requestLocationPermission(context);
                        },
                        child: Text(
                          'Try again',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ))
                  ],
                )),
    );
  }
}
