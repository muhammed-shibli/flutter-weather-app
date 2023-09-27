import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/weather_provider.dart';
import 'package:weather_app/weather_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  MobileAds.instance.initialize(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create:  (context) => WeatherProvider(),
    child: MaterialApp(darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Weather(),
     ) );
  }
}
