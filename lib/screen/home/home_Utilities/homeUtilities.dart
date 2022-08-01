import 'package:audioplayers/audioplayers.dart';

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


  Future<void> safeState() async {
    // Obtain shared preferences.

    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    final int? counter1 = prefs.getInt('indexLang1');
    final int? counter2 = prefs.getInt('indexLang2');
    setState(() {
      _selactLanguage1 = getLanguages[counter1!];
      _selactLanguage2 = getLanguages[counter2!];
    });
  }


  Future<String> getTranslate()async {
    //  String text = _textEditingControllerTrans.text;
    // Translator translator = Translator(from: _selactLanguage1!.languageCode, to: _selactLanguage2!.languageCode);
    // String translatedText = await translator.translate(text);
    // //print ('dich: ${VIETNAMESE.toString()}');
    // return translatedText;

    final gt = SimplyTranslator(EngineType.google);
    String textResult = await gt.trSimply(_textEditingControllerTrans.text,
        _selactLanguage1!.languageCode,
        _selactLanguage2!.languageCode);
    return textResult;
  }

  Future<void> getVoice1()async {
    ///use Google Translate
    final gt = SimplyTranslator(EngineType.google);
    String url = gt.getTTSUrlSimply(_textEditingControllerTrans.text, _selactLanguage1!.languageCode);

    print('url:$url');

    //await player.play();
    audioPlayer.play(url); // equivalent to setSource(UrlSource(url));
  }
  Future<void> getVoice2()async {
    ///use Google Translate
    final gt = SimplyTranslator(EngineType.google);
    String url = gt.getTTSUrlSimply(await getTranslate(), _selactLanguage2!.languageCode);

    print('url:$url');

    //await player.play();
    audioPlayer.play(url); // equivalent to setSource(UrlSource(url));
  }


  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      _lastWords = result.recognizedWords;
      _textEditingControllerTrans.text = result.recognizedWords;
      print('${result.recognizedWords} - ${result.finalResult}');
    });

    if (result.finalResult) {
      setState(() {
        _textEditingControllerTrans.text = result.recognizedWords;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    safeState();
    // translate();
    _initSpeech();
    _textEditingControllerTrans.text='';
    _textEditingControllerTrans.addListener(_printLatestValue);
  }
  void _printLatestValue() {
    print('Second text field: ${_textEditingControllerTrans.text}');
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
                        onTap: (){},
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
