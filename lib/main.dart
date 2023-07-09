import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travel Buddy'),
          backgroundColor:  Color.fromARGB(255, 242, 165, 191),
        ),
        body: Center(
          child: WeatherWidget(
            weatherService: weatherService,
            latitude: 2.3113,
            longitude: 102.4309,
          ),
        ),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  final WeatherService weatherService;
  final double latitude;
  final double longitude;

  const WeatherWidget({
    required this.weatherService,
    required this.latitude,
    required this.longitude,
  });

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherData? weatherData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
     final data = await widget.weatherService.getWeatherData(widget.latitude, widget.longitude);
      print(data); // Add this line to print the weather data
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
      print('Stack Trace: $stackTrace');
    }
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: fetchWeatherData,
          child: Text('Get Weather'),
            style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 242, 165, 191),
          ),
        ),
        SizedBox(height: 16),
        if (isLoading)
          CircularProgressIndicator()
        else if (weatherData != null)
          Card(
            margin: EdgeInsets.all(16),
            color:  Color.fromARGB(255, 242, 165, 191),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Location: ${weatherData!.location}',
                   style: TextStyle(color: Colors.white), ),
                  SizedBox(height: 8),
                  Text('Temperature: ${weatherData!.temperature}',
                   style: TextStyle(color: Colors.white), ),
                  SizedBox(height: 8),
                  Text('Description: ${weatherData!.description}',
                   style: TextStyle(color: Colors.white), ),
                ],
              ),
            ),
          )
        else
          Text('Failed to fetch weather data'),
    ],
  );
}

}
