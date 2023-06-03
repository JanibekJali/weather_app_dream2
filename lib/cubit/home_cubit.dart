import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_app/constants/texts/app_text.dart';
import 'package:weather_app/data/services/getPosition.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          cityName: "",
          country: "",
          isLoading: true,
          temp: "",
        ));

  void showWeather() async {
    final position = await GeoLocation.getPosition();
    log('position latitude ====> ${position.latitude}');
    log('position longitude ====> ${position.longitude}');
    getCurrentWeatherHttp(position: position);
  }

  Future<void> getTypedCityName({String? cityNamediBer}) async {
    try {
      final client = Client();
      final String apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=${cityNamediBer!}&appid=${AppText.myApiKey}';

      final uri = Uri.parse(apiUrl);
      final joop = await client.get(uri);

      if (joop.statusCode == 200 || joop.statusCode == 201) {
        final data = joop.body;
        final jsonData = jsonDecode(data);
        final double kelvin = jsonData['main']['temp'];
        emit(state.copywith(
            cityName: jsonData['name'],
            country: jsonData['sys']['country'],
            temp: (kelvin - 273.15).toStringAsFixed(0),
            isLoading: false));
        log('kelvin ===> $kelvin');
        log('temp ===> ${state.temp.toString()}');
      }
    } catch (e) {}
  }

  Future<void> getCurrentWeatherHttp({Position? position}) async {
    final client = Client();
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position.longitude}&appid=${AppText.myApiKey}';
    final uri = Uri.parse(url);
    try {
      final joop = await client.get(uri);
      if (joop.statusCode == 200 || joop.statusCode == 201) {
        final data = joop.body;
        final jsonData = jsonDecode(data);
        final double kelvin = jsonData['main']['temp'];

        emit(state.copywith(
          cityName: jsonData['name'],
          country: jsonData['sys']['country'],
          // temp: (kelvin - 273.15).toStringAsFixed(0),
          isLoading: false,
        ));
        log('kelvin ===> $kelvin');
        log('temp ===> ${state.temp.toString()}');
      }

      log('Cityname  ====> ${state.cityName}');
    } catch (e) {
      log('===>  $e');
    }
  }
}
