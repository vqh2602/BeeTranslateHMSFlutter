

import 'package:audioplayers/audioplayers.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:learning_translate/learning_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../../models/language.dart';

class HomeVoiceTranslateScreen extends StatefulWidget {
  const HomeVoiceTranslateScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomeVoiceTranslate();
  }
}

class _MyHomeVoiceTranslate extends State<HomeVoiceTranslateScreen> {
  Language? _selactLanguage1;
  Language? _selactLanguage2;
  TextEditingController _textEditingControllerTrans1 = TextEditingController();
  TextEditingController _textEditingControllerTrans2 = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool chat = true;

  Future<void> safeState() async {
    // Obtain shared preferences.

    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    final int? counter1 = prefs.getInt('indexLang3');
    final int? counter2 = prefs.getInt('indexLang4');
    setState(() {
      _selactLanguage1 = getLanguages[counter1!];
      _selactLanguage2 = getLanguages[counter2!];
    });
  }


  Future<void> getTranslate() async {
    //  String text = _textEditingControllerTrans.text;
    // Translator translator = Translator(from: _selactLanguage1!.languageCode, to: _selactLanguage2!.languageCode);
    // String translatedText = await translator.translate(text);
    // //print ('dich: ${VIETNAMESE.toString()}');
    // return translatedText;
if(chat) {
  final gt = SimplyTranslator(EngineType.google);
  String textResult = await gt.trSimply(_textEditingControllerTrans1.text,
      _selactLanguage1!.languageCode, _selactLanguage2!.languageCode);
  _textEditingControllerTrans2.text = textResult;
  // return textResult;
}else{
  final gt = SimplyTranslator(EngineType.google);
  String textResult = await gt.trSimply(_textEditingControllerTrans2.text,
      _selactLanguage2!.languageCode, _selactLanguage1!.languageCode);
  setState(() {
    _textEditingControllerTrans1.text = textResult;
  });
}
  }

  Future<void> getVoice1() async {
    ///use Google Translate
    final gt = SimplyTranslator(EngineType.google);
    String url = gt.getTTSUrlSimply(
        _textEditingControllerTrans1.text, _selactLanguage1!.languageCode);

    print('url:$url');

    //await player.play();
    audioPlayer.play(url); // equivalent to setSource(UrlSource(url));
  }

  Future<void> getVoice2() async {
    ///use Google Translate
    final gt = SimplyTranslator(EngineType.google);
    String url = gt.getTTSUrlSimply(
        _textEditingControllerTrans2.text, _selactLanguage2!.languageCode);

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
  if(chat){
    setState(() {
      _lastWords = result.recognizedWords;
      _textEditingControllerTrans1.text = result.recognizedWords;
      print('${result.recognizedWords} - ${result.finalResult}');
      getTranslate();
    });

    if (result.finalResult) {
      setState(() {
        _textEditingControllerTrans1.text = result.recognizedWords;
        getTranslate();
      });
    }
  }else{
    setState(() {
      _lastWords = result.recognizedWords;
      _textEditingControllerTrans2.text = result.recognizedWords;
      print('${result.recognizedWords} - ${result.finalResult}');
      getTranslate();
    });

    if (result.finalResult) {
      setState(() {
        _textEditingControllerTrans2.text = result.recognizedWords;
        getTranslate();
      });
    }
  }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    safeState();
    // translate();
    _initSpeech();
    _textEditingControllerTrans2.text='';
    _textEditingControllerTrans1.text='';
    // _textEditingControllerTrans.addListener(_printLatestValue);
  }

  // void _printLatestValue() {
  //   print('Second text field: ${_textEditingControllerTrans.text}');
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/background/bg2.jpg'),
                fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  //
                  Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: BlurryContainer(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      getVoice1();
                                                    },
                                                    child: const Icon(
                                                      Icons.record_voice_over,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      _selactLanguage1 != null
                                                          ? _selactLanguage1!
                                                              .name
                                                          : 'Chose',
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    child: TextField(
                                                      onChanged: (text) {
                                                        getTranslate();
                                                        setState(() {

                                                        });
                                                      },
                                                      controller: _textEditingControllerTrans1,
                                                      cursorColor: Colors.white,
                                                      decoration: null,
                                                      enabled:false,
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white
                                                      ),
                                                      maxLines: null,
                                                    ),
                                                    height: double.infinity,
                                                  ),)),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:_textEditingControllerTrans1.text));
                                                        FlutterToastr.show(
                                                            "Copied to Clipboard",
                                                            context,
                                                            duration:
                                                                FlutterToastr
                                                                    .lengthShort,
                                                            position:
                                                                FlutterToastr
                                                                    .bottom);
                                                      },
                                                      child: const Icon(
                                                        Icons.copy_all,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ))
                                          ],
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
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(50),
                                topRight: Radius.circular(50))),
                      )),
                  const SizedBox(
                    height: 10,
                  ),

                  Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: BlurryContainer(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      getVoice2();
                                                    },
                                                    child: const Icon(
                                                      Icons.record_voice_over,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      _selactLanguage2 != null
                                                          ? _selactLanguage2!
                                                              .name
                                                          : 'Chose',
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    child: TextField(
                                                      onChanged: (text) {
                                                        getTranslate();
                                                        setState(() {

                                                        });
                                                      },
                                                      controller: _textEditingControllerTrans2,
                                                      cursorColor: Colors.white,
                                                      decoration: null,
                                                      enabled: false,
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white
                                                      ),
                                                      maxLines: null,
                                                    ),
                                                    height: double.infinity,
                                                  ),)),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    _textEditingControllerTrans2.text));
                                                        FlutterToastr.show(
                                                            "Copied to Clipboard",
                                                            context,
                                                            duration:
                                                                FlutterToastr
                                                                    .lengthShort,
                                                            position:
                                                                FlutterToastr
                                                                    .bottom);
                                                      },
                                                      child: const Icon(
                                                        Icons.copy_all,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
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
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(0),
                                topRight: Radius.circular(50))),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    flex: 2,
                    child: BlurryContainer(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding:const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: chat?Colors.white10:Colors.transparent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        chat = true;
                                      });
                                    },
                                    child: chat?const Icon(Icons.mic_none,color: Colors.white,):const Icon(Icons.mic_off,color: Colors.white),
                                  ),
                                ),
                                DropdownButton(
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  menuMaxHeight: 300,
                                  style: const TextStyle(
                                      color: Colors.white, fontFamily: 'Inter'),
                                  value: _selactLanguage1,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.white,
                                  ),
                                  dropdownColor: Colors.black45,
                                  items: getLanguages.map((Language lang) {
                                    return DropdownMenuItem<Language>(
                                      value: lang,
                                      child: Text(lang.name,style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter'
                                      ),),
                                    );
                                  }).toList(),

                                  onChanged: (Language? val) async {
                                    final prefs =
                                    await SharedPreferences.getInstance();
                                    for (int x = 0;
                                    x < getLanguages.length;
                                    x++) {
                                      if (val?.name == getLanguages[x].name) {
                                        // Save an integer value to 'counter' key.
                                        await prefs.setInt('indexLang3', x);
                                      }
                                    }

                                    setState(() {
                                      _selactLanguage1 = val;
                                    });
                                  },
                                )
                              ],
                            )
                        ),

                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Container(
                                  padding:const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    onTap:  _selactLanguage1?.languageCode!=null?
                                    _speechToText.isNotListening
                                        ? _startListening
                                        : _stopListening
                                    : null,
                                    child: !_speechToText.isNotListening? Icon(Icons.settings_voice,color: Colors.white,size: 10.w,):Icon(Icons.keyboard_voice,color: Colors.white,size: 10.w,),
                                  )
                                ),
                              ],
                            )
                        ),

                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding:const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: !chat?Colors.white10:Colors.transparent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        chat = false;
                                      });
                                    },
                                    child: !chat?const Icon(Icons.mic_none,color: Colors.white,):const Icon(Icons.mic_off,color: Colors.white),
                                  ),
                                ),
                                DropdownButton(
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  menuMaxHeight: 300,
                                  style: const TextStyle(
                                      color: Colors.white, fontFamily: 'Inter'),
                                  value: _selactLanguage2,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.white,
                                  ),
                                  dropdownColor: Colors.black45,
                                  items: getLanguages.map((Language lang) {
                                    return DropdownMenuItem<Language>(
                                      value: lang,
                                      child: Text(lang.name,style: const TextStyle(
                                          color: Colors.white,
                                        fontFamily: 'Inter'
                                      ),),
                                    );
                                  }).toList(),

                                  onChanged: (Language? val) async {
                                    final prefs =
                                    await SharedPreferences.getInstance();
                                    for (int x = 0;
                                    x < getLanguages.length;
                                    x++) {
                                      if (val?.name == getLanguages[x].name) {
                                        // Save an integer value to 'counter' key.
                                        await prefs.setInt('indexLang4', x);
                                      }
                                    }

                                    setState(() {
                                      _selactLanguage2 = val;
                                    });
                                  },
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                    blur: 5,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    elevation: 0,
                    color: Colors.black12,
                    padding: const EdgeInsets.all(8),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),)
                ],
              ),
            ),
          )),
    );
  }
}
