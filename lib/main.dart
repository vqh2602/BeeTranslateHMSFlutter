// @dart=2.9
import 'package:beetranslatehms/repositorys/userRepositoryHMS.dart';
import 'package:beetranslatehms/screen/login_Screen/loginScreen.dart';
import 'package:beetranslatehms/screen/splash/splashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forestvpn_huawei_ads/adslite/hw_ads.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'bloc/bloc/authentication_bloc.dart';
import 'bloc/bloc/login_bloc.dart';
import 'bloc/bloc/simple_bloc_observer.dart';
import 'bloc/event/authencation_event.dart';
import 'bloc/state/authencation_state.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HwAds.init();


  // ngôn ngữ
  // WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //info app

  final UserRepositoryHMS _userRepository = UserRepositoryHMS();


  BlocOverrides.runZoned(
        () {
      // final userRepository = UserRepository();
      // userRepository.createUserWithEmailAndPassword('vqh@aaa.com', '12345678');
      runApp(

        RootRestorationScope(
            restorationId: 'root',
            child:  MultiBlocProvider(
                  providers: [
                    BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(userRepository: _userRepository),
                    ),
                    BlocProvider<AuthenticationBloc>(
                      create: (BuildContext context) => AuthenticationBloc(userRepository: _userRepository),
                    ),
                  ],
                  child: MyApp(userRepository: _userRepository,),
                )
            )
      );
    },
    blocObserver: SimpleBlocObserver(),
  );

  // final userRepository = UserRepository();
  // userRepository.createUserWithEmailAndPassword('vqh@aaa.com', '123456');
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepositoryHMS userRepository;

  const MyApp({Key key,this.userRepository}) : super(key: key);

  static const MaterialColor mcgpalette0 = MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
    50: Color(0xFFEBF5FC),
    100: Color(0xFFCDE6F7),
    200: Color(0xFFABD6F2),
    300: Color(0xFF89C5ED),
    400: Color(0xFF70B8E9),
    500: Color(_mcgpalette0PrimaryValue),
    600: Color(0xFF4FA5E2),
    700: Color(0xFF469BDE),
    800: Color(0xFF3C92DA),
    900: Color(0xFF2C82D3),
  });
  static const int _mcgpalette0PrimaryValue = 0xFF57ACE5;

  static const MaterialColor mcgpalette0Accent = MaterialColor(_mcgpalette0AccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_mcgpalette0AccentValue),
    400: Color(0xFFADD6FF),
    700: Color(0xFF94C9FF),
  });
  static const int _mcgpalette0AccentValue = 0xFFE0F0FF;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Sizer(builder: (context, orientation, deviceType) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: mcgpalette0,
      ),
      // home:  LoginScreenHMS(),
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {

            if (authenticationState is AuthenticationStateSuccess) {

              // return Text("done");
              return SplashScreen( user: authenticationState.user);
                //SplashScreen( userRepository: _userRepository,),

            } else if (authenticationState is AuthenticationStateFailure) {

              //return Text("Fail");
              return BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(userRepository: userRepository),
                child: LoginScreen(userRepository: userRepository),
              );
            } else {

              return BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(userRepository: userRepository),
                child: LoginScreen(userRepository: userRepository),
              );
            }
          },
        ),
      ),
    ));
  }
}

