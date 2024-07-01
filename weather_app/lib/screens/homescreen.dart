import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/const.dart';
import 'weatherdetailscreen.dart';
import 'package:weather_app/components/searchbar.dart'
    as CustomSearchBar; // Renaming import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  void _loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSearchedCity = prefs.getString('lastSearchedCity');
    if (lastSearchedCity != null) {
      _controller.text = lastSearchedCity;
      _fetchWeather(lastSearchedCity);
    }
  }

  void _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lastSearchedCity', cityName);

      Weather weather = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(
            weather: weather,
            onRefresh: () {
              Navigator.pop(context);
              _fetchWeather(cityName);
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Could not fetch weather data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar.SearchBar(
              // Using the renamed import
              controller: _controller,
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _fetchWeather(_controller.text);
                }
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
