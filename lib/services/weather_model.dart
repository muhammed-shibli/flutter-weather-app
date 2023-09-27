class WeatherModel{

  final double temperature;
  final String condition;
  final int humidity;
  final String country;
  final String city;
  final String description;


  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.country,
    required this.city,
    required this.description,
  
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    
    return WeatherModel(
        temperature: json['main']['temp'],
        condition: json['weather'][0]['main'],
        humidity: json['main']['humidity'],
        country: json['sys']['country'],
        city: json['name'],
        description: json['weather'][0]['description'],);
  }
}
