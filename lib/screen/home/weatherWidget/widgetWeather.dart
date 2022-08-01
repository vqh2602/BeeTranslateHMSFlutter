

import 'package:flutter/material.dart';

Widget currentWeather(String city, String temp, int status){
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('$city,',style: TextStyle(
          color: Colors.grey,
          fontFamily: 'Inter'
        ),),
        Text(' $temp℃  ',style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Inter',
        ),),
        Image.asset('assets/images/weather/${getIconWeather(status)}.png',width: 30,)
      ],
    ),
  );
}



String getIconWeather(int x){
  TimeOfDay day = TimeOfDay.now();
  int hours = DateTime.now().hour;
 if(x == 1 || x ==2 || x ==30 || x==33 || x==34){
   switch(checkDayNight(hours)){
     case 1: return 'w1';
     break;
     case 0: return 'w13';
     default: return 'w0';
   }
 }else if(x == 3){

   switch(day.period){
     case DayPeriod.am: return 'w2';
     break;
     case DayPeriod.pm: return 'w11';
     default: return 'w0';
   }
 }else if(x == 4 || x ==5 || x ==35 || x==36){
   switch(checkDayNight(hours)){
     case 1: return 'w3';
     break;
     case 0: return 'w11';
     default: return 'w0';
   }
 }else if(x == 14 ){
   switch(checkDayNight(hours)){
     case 1: return 'w4';
     break;
     case 0: return 'w12';
     default: return 'w0';
   }
 }else if(x == 6 || x ==7 || x ==8 || x==38 || x==43){
   return 'w5';
 }else if(x == 13 || x ==12 || x ==18 || x==39 || x==43){
   return 'w6';
 }else if(x == 15 || x ==16 || x ==17 || x==41 || x==42){
   return 'w7';
 }else if(x == 11 ){
   return 'w8';
 }else if(x == 14 || x ==20 || x ==21 || x==22 || x==44 || x == 29){
   return 'w9';
 }else if(x == 24 || x ==25 || x ==26 ){
   return 'w10';
 }else{
   //37
   return 'w11';
 }
}

int checkDayNight(int hours){
  // if (hour < 12) {
  //   return 'Morning';
  // }
  if (hours < 17) {
    return 1;
  }else {
    return 0;
  }
}

//
//
// const baseUrl = "https://api.openweathermap.org/data/2.5/weather?";
// const baseUrlAll = 'https://api.openweathermap.org/data/2.5/onecall?';
// const appid = "1ab5e5b50cd31038fe5265dea5a1df86";
// //late final LoctionUrl  = (lat,long,lang) => "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$appid&units=metric&lang=$lang";
// late final LoctionUrl  = (lat,long,lang) => "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&exclude=minutely,daily,alerts&appid=$appid&units=metric&lang=$lang";
//
// class WeatherRepositories {
//   late final http.Client httpClient;
//
//   WeatherRepositories({required this.httpClient});
//
//   Future<WeatherMain> fetchWeather ( String lat, long, lang) async{
//     final response = await httpClient.get(Uri.parse(LoctionUrl(lat,long,lang)));
//     print("check repornt ${response.statusCode} and/ ${Uri.parse(LoctionUrl(lat,long,lang).toString())}");
//     if(response.statusCode !=200){
//       print("lôi call api");
//       throw Exception("lỗi lấy thời tiết - WeatherRepositories");
//     }else{
//       final weatherJson = jsonDecode(response.body);
//       print("call api thanh cong");
//       return WeatherMain.fromJson(weatherJson);
//     }
//   }
// }
//
//
//
//
//
// @immutable
// class WeatherMain {
//   num? lat;
//   num? lon;
//   String? timezone;
//   num? timezoneOffset;
//   Current? current;
//   List<Hourly>? hourly;
//
//   WeatherMain(
//       {this.lat,
//         this.lon,
//         this.timezone,
//         this.timezoneOffset,
//         this.current,
//         this.hourly});
//
//   factory WeatherMain.fromJson(dynamic json) {
//     if (json == null) {
//       return WeatherMain();
//     } else {
//       print('covert thanh cong');
//       return WeatherMain(
//           lat: json['lat'],
//           lon: json['lon'],
//           timezone: json['timezone'],
//           timezoneOffset: json['timezone_offset'],
//           current: Current.fromJson(json['current']),
//           hourly: (json['hourly'] as List).map((e) => Hourly.fromJson(e)).toList());
//     }
//
//   }
//
// }
//
//
// class Weather {
//   num? id;
//   String? main;
//   String? description;
//   String? icon;
//
//   Weather({this.id, this.main, this.description, this.icon});
//
//   factory Weather.fromJson(dynamic json) {
//     if (json == null) {
//       return Weather();
//     } else {
//       return Weather(
//         id: json['id'],
//         main: json['main'],
//         description: json['description'],
//         icon: json['icon'],
//       );
//     }
//   }
// }
//
// class Current {
//   num? dt;
//   num? sunrise;
//   num? sunset;
//   num? temp;
//   num? feelsLike;
//   num? pressure;
//   num? humidity;
//   num? dewPoint;
//   num? uvi;
//   num? clouds;
//   num? visibility;
//   num? windSpeed;
//   num? windDeg;
//   List<Weather>? weather;
//
//   Current(
//       {this.dt,
//         this.sunrise,
//         this.sunset,
//         this.temp,
//         this.feelsLike,
//         this.pressure,
//         this.humidity,
//         this.dewPoint,
//         this.uvi,
//         this.clouds,
//         this.visibility,
//         this.windSpeed,
//         this.windDeg,
//         this.weather});
//
//   factory Current.fromJson(dynamic json) {
//     if (json == null) {
//       return Current();
//     } else {
//       return Current(
//         dt: json['dt'],
//         sunrise: json['sunrise'],
//         sunset: json['sunset'],
//         temp: json['temp'],
//         feelsLike: json['feels_like'],
//         pressure: json['pressure'],
//         humidity: json['humidity'],
//         dewPoint: json['dew_point'],
//         uvi: json['uvi'],
//         clouds: json['clouds'],
//         visibility: json['visibility'],
//         windSpeed: json['wind_speed'],
//         windDeg: json['wind_deg'],
//         weather:
//         (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
//       );
//     }
//   }
// }
//
//
// class Hourly {
//   num? dt;
//   num? temp;
//   num? feelsLike;
//   num? pressure;
//   num? humidity;
//   num? dewPoint;
//   num? uvi;
//   num? clouds;
//   num? visibility;
//   num? windSpeed;
//   num? windDeg;
//   num? windGust;
//   List<Weather>? weather;
//   num? pop;
//
//   Hourly(
//       {this.dt,
//         this.temp,
//         this.feelsLike,
//         this.pressure,
//         this.humidity,
//         this.dewPoint,
//         this.uvi,
//         this.clouds,
//         this.visibility,
//         this.windSpeed,
//         this.windDeg,
//         this.windGust,
//         this.weather,
//         this.pop});
//
//   factory Hourly.fromJson(dynamic json) {
//     if (json == null) {
//       return Hourly();
//     } else {
//       return Hourly(
//         dt: json['dt'],
//         temp: json['temp'],
//         feelsLike: json['feels_like'],
//         pressure: json['pressure'],
//         humidity: json['humidity'],
//         dewPoint: json['dew_point'],
//         uvi: json['uvi'],
//         clouds: json['clouds'],
//         visibility: json['visibility'],
//         windSpeed: json['wind_speed'],
//         windDeg: json['wind_deg'],
//         windGust: json['wind_gust'],
//         weather:
//         (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
//         pop: json['pop'],
//       );
//     }
//   }
// }
