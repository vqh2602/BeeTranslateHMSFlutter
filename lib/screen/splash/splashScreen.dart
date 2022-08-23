import 'package:beetranslatehms/bloc/bloc/authentication_bloc.dart';
import 'package:beetranslatehms/bloc/state/authencation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huawei_account/huawei_account.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../Color/colors.dart';
import '../../ads/hmsAdKit.dart';
import '../home/homeScreen.dart';



class SplashScreen extends StatefulWidget {
 AuthAccount user;

  SplashScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MySplashScreen();
  }
}

class _MySplashScreen extends State<SplashScreen> {
  AuthAccount get user => widget.user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _userBloc = BlocProvider.of<UserBloc>(context);
    Future.delayed(const Duration(seconds: 2),(){
      createAdHms()
        ..loadAd()
        ..show();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 25)),
                        Image.asset(
                          'assets/image/logo/logo.jpg',
                          width: 200,
                          height: 200,
                        ),
                        GradientText(
                                'Bee Translate',
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                                colors: [
                                  Colors.blue,
                                  Colors.cyanAccent
                                ],
                              ),
                        // GradientText(
                        //   'Meow Assistan ${user.displayName}',
                        //   style: const TextStyle(
                        //     fontSize: 25,
                        //   ),
                        //   colors: [
                        //     colorPinkFf758c(),
                        //     colorPinkFf7eb3()
                        //   ],
                        // ),
                        const Padding(padding: EdgeInsets.only(top: 25)),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        )
                      ],
                    )),
                SizedBox(
                  child: Column(
                    children: [
                      const Text('from',style: TextStyle(color: Colors.grey),),
                      Image.asset(
                        'assets/image/logo/logova.png',
                        width: 50,
                        height: 50,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
