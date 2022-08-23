
import 'package:beetranslatehms/screen/home/home_Utilities/utilities/weatherWidget/widgetWeather.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:huawei_awareness/awarenessCaptureClient.dart';
import 'package:huawei_awareness/dataTypes/captureTypes/weather/dailyWeather.dart';
import 'package:huawei_awareness/dataTypes/captureTypes/weatherResponse.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:location_service_check/location_service_check.dart';
import 'package:sizer/sizer.dart';

class WeatherScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyWeatherScreen();
  }

}
class _MyWeatherScreen extends State<WeatherScreen>{
  PermissionHandler permissionHandler = PermissionHandler();
  late List<DailyWeather> lstdaily;

  Future<void> checkInternetLocation() async {
    bool isOpen = await LocationServiceCheck.checkLocationIsOpen;
    print('bat vi tri $isOpen');
    if (!isOpen) {
      // Use location.
      await LocationServiceCheck.openLocationSetting();
    }
    try {
      bool status = await permissionHandler.requestLocationPermission();
      // true if permissions are granted; false otherwise
    } catch (e) {
      print(e.toString);
    }
  }
  Future<WeatherResponse> getTesst() async {
    //print('thoitiet1: ');

    WeatherResponse response = await AwarenessCaptureClient.getWeatherByDevice();
    print('thoitiet: ${response.dailyWeather.length}');
    return response;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternetLocation();
    getTesst();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/image/background/u3.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child:  Align(
            alignment: FractionalOffset.topCenter,
            child: SizedBox(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    child: FutureBuilder<WeatherResponse>(
                      future: getTesst(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<WeatherResponse> snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 20,),

                              Container(
                                height: 40.h,
                                child: currentWeather(
                                    snapshot.data!.weatherSituation.city.name,
                                    snapshot
                                        .data!.weatherSituation.situation.temperatureC
                                        .toString(),
                                    snapshot
                                        .data!.weatherSituation.situation.weatherId,
                                    snapshot
                                        .data!.weatherSituation.situation.windSpeed,
                                    snapshot
                                        .data!.weatherSituation.situation.uvIndex,
                                    snapshot
                                        .data!.weatherSituation.situation.humidity,
                                    context),
                              ),
                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text('HOURLY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 10.sp,

                                    ),),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  height: 25.h,
                                  child:BlurryContainer(
                                    child:  ListView.builder(
                                      itemCount:snapshot.data!.hourlyWeather!.length,
                                      itemBuilder: (context, i){
                                        //print('apivalue:' + snapshot.data!.dailyWeather[i].situationDay.weatherId);
                                        return currentWeatherHourly(
                                            snapshot.data!.hourlyWeather[i].dateTimeStamp,
                                            snapshot.data!.hourlyWeather[i].weatherId,
                                            snapshot.data!.hourlyWeather[i].tempC,
                                            snapshot.data!.hourlyWeather[i].isDayNight,
                                            context
                                        );
                                      },
                                    ),
                                    blur: 5,
                                    elevation: 0,
                                    color: Colors.black26,
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: MediaQuery.of(context).size.height * 0.4,
                                    padding: const EdgeInsets.all(8),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  )

                              ),

                              SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text('DAILY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontSize: 10.sp,

                                    ),),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                width: double.infinity,
                                height: 21.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:snapshot.data!.dailyWeather!.length,
                                  itemBuilder: (context, i){
                                    //print('apivalue:' + snapshot.data!.dailyWeather[i].situationDay.weatherId);
                                    return currentWeatherDaily(
                                        snapshot.data!.dailyWeather[i].dateTimeStamp,
                                        snapshot.data!.dailyWeather[i].situationDay.weatherId,
                                        snapshot.data!.dailyWeather[i].maxTempC,
                                        snapshot.data!.dailyWeather[i].minTempC,
                                        snapshot.data!.dailyWeather[i].situationDay.windSpeed,
                                        snapshot.data!.dailyWeather[i].situationDay.windDir,
                                        context
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),

                            ],
                          );

                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('stop like there was an error, please check network connection, location services. if the condition persists please restart the utility',style: TextStyle(
                                color: Colors.red
                              ),),
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Loading weather data...\nPlease wait a few minutes. usually it takes some time to load data for the first time'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

}