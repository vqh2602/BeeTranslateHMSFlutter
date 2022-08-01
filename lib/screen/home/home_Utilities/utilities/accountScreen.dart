import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../bloc/bloc/authentication_bloc.dart';
import '../../../../bloc/event/authencation_event.dart';
import '../../../../bloc/state/authencation_state.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAcc();
  }


}
class _MyAcc extends State<AccountScreen>{
  late AuthenticationBloc _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = BlocProvider.of<AuthenticationBloc>(context);
    _auth.add(AuthenticationEventStarted());
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/image/background/u1.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              child: BlurryContainer(
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authenticationState) {
                    if (authenticationState is AuthenticationStateSuccess) {
                      // return Text("done");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(authenticationState.user.avatarUri!),
                              radius: 13.h,
                            ),
                          ),
                          Text('--------------',style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp
                          ),),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Align(
                              child: Column(
                                children: [
                                  Text('Hi!, '+authenticationState.user.displayName!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: 'Inter'
                                    ),),
                                  Text('Email: ${authenticationState.user.email==null?'No email':authenticationState.user.email}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: 'Inter'
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          Text('--------------',style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp
                          ),),
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              onTap: (){
                                _auth.add(AuthenticationEventLogout());
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false);// Prints after 1 second.
                                });
                              },
                              child: Text('Logout',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                fontFamily: 'Inter'
                              ),),
                            ),
                          )
                        ],
                      );
                      //SplashScreen( userRepository: _userRepository,),

                    } else if (authenticationState is AuthenticationStateFailure) {

                      //return Text("Fail");
                      return Padding(padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),);
                    } else {

                      return Container(
                        child: Text(
                          'Error!',
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ),
                      );
                    }
                  },
                ),
                blur: 5,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                elevation: 0,
                color: Colors.black26,
                padding: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

