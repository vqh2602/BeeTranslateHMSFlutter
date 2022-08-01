import 'package:audioplayers/audioplayers.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:learning_translate/learning_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../../models/language.dart';

class HomeTextTranslateScreen extends StatefulWidget {
  const HomeTextTranslateScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomeTextTranslate();
  }
}

class _MyHomeTextTranslate extends State<HomeTextTranslateScreen> {
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
                image: AssetImage('assets/image/background/bg1.jpg'),
                fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              child: Column(
                children: [
                  BlurryContainer(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  // Text('Anh'),
                                  DropdownButton(
                                    underline: const SizedBox(),
                                    menuMaxHeight: 300,
                                    hint: const Text(
                                      'Choose',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter'),
                                    ),
                                    style: const TextStyle(
                                        color: Colors.white, fontFamily: 'Inter'),
                                    value: _selactLanguage1,
                                    // icon: const Icon(
                                    //   Icons.arrow_drop_down_sharp,
                                    //   color: Colors.white,
                                    // ),
                                    dropdownColor: Colors.black45,
                                    items: getLanguages.map((Language lang) {
                                      return DropdownMenuItem<Language>(
                                        value: lang,
                                        child: Text(
                                          lang.name,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
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
                                          await prefs.setInt('indexLang1', x);
                                        }
                                      }

                                      setState(() {
                                        _selactLanguage1 = val;
                                      });
                                    },
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                var y = await getTranslate();
                                setState((){
                                  var x = _selactLanguage1;
                                  _selactLanguage1 = _selactLanguage2;
                                  _selactLanguage2 = x;
                                  _textEditingControllerTrans.text = y;

                                });
                              },
                              child: const Icon(
                                Icons.compare_arrows_outlined,
                                color: Colors.white,
                              ),
                            )),
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  DropdownButton(
                                    underline: const SizedBox(),
                                    menuMaxHeight: 300,
                                    hint: const Text(
                                      'Choose',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter'),
                                    ),
                                    style: const TextStyle(
                                        color: Colors.white, fontFamily: 'Inter'),
                                    value: _selactLanguage2,
                                    // icon: const Icon(
                                    //   Icons.arrow_drop_down_sharp,
                                    //   color: Colors.white,
                                    // ),
                                    dropdownColor: Colors.black45,
                                    items: getLanguages.map((Language lang) {
                                      return DropdownMenuItem<Language>(
                                        value: lang,
                                        child: Text(
                                          lang.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                                          await prefs.setInt('indexLang2', x);
                                        }
                                      }

                                      setState(() {
                                        _selactLanguage2 = val;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                    blur: 5,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    elevation: 0,
                    color: Colors.black26,
                    padding: const EdgeInsets.all(8),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  //
                  Expanded(
                      flex: 5,
                      child:Container(
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                onTap: (){
                                                  getVoice1();
                                                },
                                                child: const Icon(Icons.record_voice_over,color: Colors.white,),
                                              ),
                                                const SizedBox(width: 20,),
                                                Text(_selactLanguage1 != null?_selactLanguage1!.name:'Chose',style:
                                                const TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.white
                                                )),],
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    _textEditingControllerTrans.text='';
                                                    audioPlayer.dispose();
                                                  });
                                                },
                                                child: const Icon(Icons.playlist_remove_outlined,color: Colors.white,),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                Expanded(
                                    flex: 9,
                                    child:Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                            borderRadius: BorderRadius.circular(10)),
                                      child: Stack(
                                        children:  [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextField(
                                              onChanged: (text) {
                                                getTranslate();
                                                setState(() {

                                                });
                                              },
                                              controller: _textEditingControllerTrans,
                                              cursorColor: Colors.white,
                                              decoration: null,
                                              enabled: _selactLanguage1!= null ? true:false,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white
                                              ),
                                              maxLines: null,
                                            ),
                                            height: double.infinity,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              onTap: _speechToText.isNotListening
                                                  ? _startListening
                                                  : _stopListening,
                                              child: _speechToText.isNotListening?const Icon(Icons.keyboard_voice_outlined,color: Colors.white,):const Icon(Icons.settings_voice,color: Colors.white,),
                                            ),
                                          )
                                        ],
                                      ),
                                    ) ),
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
                      ) ),
                  const SizedBox(height: 10,),
                  Expanded(
                      flex: 5,
                      child:Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: BlurryContainer(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(_selactLanguage2 != null?_selactLanguage2!.name:'Chose',style:
                                      const TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.white
                                      )),
                                    )),
                                Expanded(
                                    flex: 10,
                                    child:Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children:  [
                                          Expanded(
                                            flex:5,
                                            child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: SingleChildScrollView(
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child:
                                                FutureBuilder<String>(
                                                  future: getTranslate(), // a previously-obtained Future<String> or null
                                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                                    if (snapshot.hasData) {
                                                     return Text(
                                                        snapshot.data!,
                                                        style: const TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Colors.white
                                                        ),
                                                      );

                                                    } else if (snapshot.hasError) {
                                                      return const Text(
                                                        'there seems to be a problem, wait a moment.'
                                                            ' if it takes too long please check the'
                                                            ' network connection, or restart the app',
                                                        style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Colors.red
                                                        ),
                                                      );

                                                    } else {
                                                      return const Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Colors.white
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                // Text(
                                                //   _textEditingControllerTrans.text,
                                                //   style: const TextStyle(
                                                //       fontFamily: 'Inter',
                                                //       color: Colors.white
                                                //   ),
                                                // ),
                                              ),
                                            ))),
                                          Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  getVoice2();
                                                },
                                                child: const Icon(Icons.record_voice_over,color: Colors.white,),
                                              ),
                                              const SizedBox(width: 20,),
                                              InkWell(
                                                onTap: () async {
                                                  Clipboard.setData(ClipboardData(text:await getTranslate() ));
                                                  FlutterToastr.show("Copied to Clipboard", context, duration: FlutterToastr.lengthShort, position:  FlutterToastr.bottom);

                                                },
                                                child: const Icon(Icons.copy_all,color: Colors.white,),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ) ),
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
                      ) ),
                ],
              ),
            ),
          )),
    );
  }
}
