part of 'home_cubit.dart';

class HomeState {
  final String? cityName;
  final String? temp;
  final String? country;
  final bool? isLoading;

  HomeState({this.cityName, this.temp, this.country, this.isLoading});
  HomeState copywith(
      {String? cityName, String? temp, String? country, bool? isLoading}) {
    return HomeState(
        cityName: cityName ?? this.cityName,
        country: country ?? this.country,
        isLoading: isLoading ?? this.isLoading,
        temp: temp ?? this.temp);
  }
}
