import 'package:audioplayers/audioplayers.dart';
import 'package:beetranslatehms/screen/home/home_Utilities/utilities/accountScreen.dart';
import 'package:beetranslatehms/screen/home/home_Utilities/utilities/weatherWidget/weatherScreen.dart';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../../models/language.dart';
import 'utilities/scanKitWithHMS.dart';
import 'utilities/SafeKitHMS.dart';
import 'utilities/versionAppScreen.dart';


class HomeUtilitiesScreen extends StatefulWidget {
  const HomeUtilitiesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomeUtilitiesScreen();
  }
}

class _MyHomeUtilitiesScreen extends State<HomeUtilitiesScreen> {
  Language? _selactLanguage1;
  Language? _selactLanguage2;
  TextEditingController _textEditingControllerTrans= TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/background/bg4.jpg'),
                fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // acc
                    BlurryContainer(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AccountScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex:1,
                                child: Container(
                                  padding:EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.account_circle,color: Colors.white,size: 50.sp,),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  padding:const EdgeInsets.all(10),
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child: Text('Account',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 20,),
                    // qr
                    BlurryContainer(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ScanKitWithHMS()),
                          );

                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex:1,
                                child: Container(
                                  padding:EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.qr_code,color: Colors.white,size: 50.sp,),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  padding:const EdgeInsets.all(10),
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child: Text('Barcode Scanner',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 20,),
                    //weather
                    BlurryContainer(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WeatherScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex:1,
                                child: Container(
                                  padding:EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.cloud,color: Colors.white,size: 50.sp,),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  padding:const EdgeInsets.all(10),
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child: Text('Weather',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 20,),
                    //safe
                    BlurryContainer(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SafeKitHMS()),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex:1,
                                child: Container(
                                  padding:EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.verified_user,color: Colors.white,size: 50.sp,),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  padding:const EdgeInsets.all(10),
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child: Text('Safe detection',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(height: 20,),
                    //about
                    BlurryContainer(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VersionAppScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex:1,
                                child: Container(
                                  padding:EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(Icons.info,color: Colors.white,size: 50.sp,),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  padding:const EdgeInsets.all(10),
                                  child:  Align(
                                    alignment: Alignment.center,
                                    child: Text('App info',style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
