
import 'package:beetranslatehms/bloc/state/login_state.dart';
import 'package:beetranslatehms/screen/splash/splashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huawei_account/huawei_account.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sizer/sizer.dart';

import '../../Color/colors.dart';
import '../../bloc/bloc/login_bloc.dart';
import '../../bloc/event/login_event.dart';
import '../../bloc/state/login_state.dart';
import '../../repositorys/userRepositoryHMS.dart';
import 'loginScreenMin.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';
  late UserRepositoryHMS? userRepository;
  LoginScreen({Key? key, this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MyLoginScreen();
  }
}

class _MyLoginScreen extends State<LoginScreen> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  late LoginBloc _loginBloc;
  UserRepositoryHMS? get userRepository => widget.userRepository;
  PermissionHandler permissionHandler = PermissionHandler();



  Future<void> checkHMS() async{
    HmsApiAvailability client = new HmsApiAvailability();
    // 0: HMS Core (APK) is available.
// 1: No HMS Core (APK) is found on device.
// 2: HMS Core (APK) installed is out of date.
// 3: HMS Core (APK) installed on the device is unavailable.
// 9: HMS Core (APK) installed on the device is not the official version.
// 21: The device is too old to support HMS Core (APK).
    int status = await client.isHMSAvailable();
    print('trang thai hms: $status');
    if(status != 0){
      // Set a listener to track events
      client.setResultListener = ((AvailabilityResultListener listener) {

      }) as AvailabilityResultListener;
      client.getErrorDialog(status, 1000,true);
    }

    try {
      bool status = await permissionHandler.requestLocationPermission();
      // true if permissions are granted; false otherwise
    } catch (e) {
      print(e.toString);
    }


// Specify the status code you get, a request code and decide if
// you want to listen dialog cancellations.


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    // textEditingControllerEmail.addListener(() {
    //   _loginBloc.add(LoginEventEmailChange(email: textEditingControllerEmail.text));
    // });
    // textEditingControllerPassword.addListener(() {
    //   _loginBloc.add(LoginEventPasswordChange(password: textEditingControllerPassword.text));
    // });

    checkHMS();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocBuilder<LoginBloc, UserState>(
        builder: (context, loginState) {
          if (loginState is UserStateFail) {
            print('login fail');
            return _safeArea(loginState,'Tài khoản hoặc mật khẩu không đúng, \n hoặc không có kết nối mạng');
          } else if (loginState is UserStateSuccess) {
            //BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLogin());
            return SplashScreen(user: loginState.user);
          } else {
            return _safeArea(loginState,'');
          }
        },
      ),
    );
  }

  SafeArea _safeArea(UserState loginState,String title){
    return SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          // padding: const EdgeInsets.only(left: 10, right: 10),
          // decoration: const BoxDecoration(
          //     // image: DecorationImage(
          //     //   image: AssetImage('assets/images/logo/meow.png'),
          //     //   // fit: BoxFit.cover,
          //     // ),
          //
          //     ),
          child: Center(
            child: Column(
              children: <Widget>[
                // Expanded(
                //   flex: 4,
                //   child: SizedBox(
                //     width: double.infinity,
                //     // color: Colors.grey,
                //     child: Align(
                //         alignment: Alignment.topRight,
                //         child: Image.asset(
                //           'acssets/images/cats/catfoot.png',
                //           // width: 250,
                //         )),
                //   ),
                // ),
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter'),
                              ),
                              Text(
                                'Please sign in to continue',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontFamily: 'Inter'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:MediaQuery.of(context).size.width * 0.9,
                          child: HuaweiIdAuthButton(
                              theme: AuthButtonTheme.FULL_TITLE,
                              buttonColor: AuthButtonBackground.RED,
                              borderRadius: AuthButtonRadius.MEDIUM,
                              onPressed: () {
                                // call desired method
                                _onLoginEmailAndPassword();
                              }),
                        )

                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Do not have an account?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontFamily: 'Inter',
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              // AuthAccount  _id = await AccountAuthManager.getAuthResult();
                              // print("lấy thôgn tin: ${_id.displayName}");
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Please login, register with huawei')));
                              // Navigator.pushNamed(
                              //   context,
                              //   RegisterScreen.routeName,
                              //   arguments: {'userRegistory': userRepository}
                              // );
                              // Navigator.of(context).push(
                              //   // MaterialPageRoute(builder: (context){
                              //   //  return BlocProvider<RegisterBloc>(
                              //   //  create: (context)=> RegisterBloc(userRepository: userRepository),
                              //   //    child: RegisterScreen(userRepository: userRepository),
                              //   //  );
                              //   // })
                              // );
                            },
                            child: Text(
                              'sign up',
                              style: TextStyle(
                                  color: colorPinkFf758c(),
                                  fontSize: 17,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ));
  }

  void _onLoginEmailAndPassword(){

    print('nhạn mail va pass');
    _loginBloc.add(LoginEventWithHMSPressed());
    // _userBloc.add(GetUser(user: null));

  }
}
