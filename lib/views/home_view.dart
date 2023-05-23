import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_app/constants/texts/app_text.dart';
import 'package:weather_app/views/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String cityName = '';

  dynamic temp;

  String country = '';
  bool isLoading = true;

  @override
  void initState() {
    showWeather();

    super.initState();
  }

  void showWeather() async {
    final position = await getPosition();
    log('position latitude ====> ${position.latitude}');
    log('position longitude ====> ${position.longitude}');
    getCurrentWeatherHttp(position: position);
  }

  Future<void> getCurrentWeatherHttp({Position? position}) async {
    final client = Client();
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=${AppText.myApiKey}';
    final uri = Uri.parse(url);
    try {
      final joop = await client.get(uri);
      if (joop.statusCode == 200 || joop.statusCode == 201) {
        final data = joop.body;
        final jsonData = jsonDecode(data);
        cityName = jsonData['name'];
        country = jsonData['sys']['country'];
        final double kelvin = jsonData['main']['temp'];
        temp = (kelvin - 273.15).toStringAsFixed(0);
        log('kelvin ===> $kelvin');
        log('temp ===> ${temp.toString()}');
      }

      log('Cityname  ====> ${cityName}');
      setState(() {});
      isLoading = false;
    } catch (e) {
      log('===>  $e');
    }
  }

  Future<void> getTypedCityName({String? cityNamediBer}) async {
    isLoading = true;
    try {
      final client = Client();
      final String apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=${cityNamediBer!}&appid=${AppText.myApiKey}';

      final uri = Uri.parse(apiUrl);
      final joop = await client.get(uri);
      if (joop.statusCode == 200 || joop.statusCode == 201) {
        final data = joop.body;
        final jsonData = jsonDecode(data);
        cityName = jsonData['name'];
        country = jsonData['sys']['country'];
        final double kelvin = jsonData['main']['temp'];
        temp = (kelvin - 273.15).toStringAsFixed(0);
        log('kelvin ===> $kelvin');
        log('temp ===> ${temp.toString()}');
        isLoading = false;
        setState(() {});
      }
    } catch (e) {}
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('kata bolup atat');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              showWeather();
            },
            child: Icon(
              Icons.near_me,
              size: 40,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchView()));
                getTypedCityName(cityNamediBer: result);
              },
              icon: Icon(
                Icons.location_city,
                size: 40,
              ),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Positioned(
                      top: 90,
                      left: 40,
                      child: Text(
                        '$temp°C',
                        style: TextStyle(
                          fontSize: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 40,
                      child: Text(
                        'Country: $country',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 190,
                      child: Text(
                        ' ⛅',
                        style: TextStyle(
                          fontSize: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 220,
                      left: 100,
                      right: 0,
                      child: Text(
                        'Jiluu \n kiyinip 👕   \n chyk',
                        style: TextStyle(
                          fontSize: 55,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '$cityName',
                        style: TextStyle(
                          fontSize: 55,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
