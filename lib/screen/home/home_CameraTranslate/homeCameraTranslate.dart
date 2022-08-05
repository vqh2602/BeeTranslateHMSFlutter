import 'dart:convert';
import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:huawei_ml_text/huawei_ml_text.dart';
import 'package:huawei_scan/hmsScanPermissions/HmsScanPermissions.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplytranslate/simplytranslate.dart';

import '../../../models/language.dart';

class MLTextWithHMSScreen extends StatefulWidget {
  const MLTextWithHMSScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MyScanKitWithHMS();
  }
}

class _MyScanKitWithHMS extends State<MLTextWithHMSScreen> {
  DateTime? selectedDate = DateTime.now();
  int? textureId;
  TextEditingController _textEditingControllerTrans = TextEditingController();
  Language? _selactLanguage1;

  final controller = MLTextLensController(
      // Set the transaction type
      transaction: TextTransaction.text,
      // Set the lens to front or back
      lensType: MLTextLensController.backLens);

// Create a lens engine object and specify the controller.
  List<TextBlock> listTB = [];
  bool start = false;

  Future<void> checkQuyen() async {
    await HmsScanPermissions.requestCameraAndStoragePermissions();
    //Call hasCameraAndStoragePermission API.
    bool? permissionStatus =
        await HmsScanPermissions.hasCameraAndStoragePermission();
//Print status.
    //debugPrint(permissionStatus?.toString());
  }

  Future<void> startScan() async {
    // Create a variable for lens texture.
// This variable will bind native texture with app's texture.

// Create a lens controller.
    final engine = MLTextLensEngine(controller: controller);
// To get real time transaction results, create a listener callback.
    void onTransaction({dynamic result}) async {
      setState(() {
        listTB = result;
        _textEditingControllerTrans.text = listTB[0].stringValue!;
      });
      print('ket qua: ${listTB[0].stringValue}');
      //listTB.add(result);
    }

// Then pass the callback to engine's setTransactor method.
    engine.setTransactor(onTransaction);

// Initialize the texture for camera stream.
    await engine.init().then((value) {
      // Set the textureId variable to returned value.
      // Then the texture will be ready to stream
      setState(() => textureId = value);
    });

// Call run method to start the stream
    engine.run();

// To destroy the stream, call release method.
// Call init method again to get the texture ready.
    // engine.release();

    // await HmsScanUtils.disableLogger();
  }

  Future<void> safeState() async {
    // Obtain shared preferences.

    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    final int? counter1 = prefs.getInt('indexLang5');
    setState(() {
      _selactLanguage1 = getLanguages[counter1!];
    });
  }

  Future<String> getTranslate() async {
    //  String text = _textEditingControllerTrans.text;
    // Translator translator = Translator(from: _selactLanguage1!.languageCode, to: _selactLanguage2!.languageCode);
    // String translatedText = await translator.translate(text);
    // //print ('dich: ${VIETNAMESE.toString()}');
    // return translatedText;

    final gt = SimplyTranslator(EngineType.google);
    var gtransl = await gt.translateSimply(_textEditingControllerTrans.text,
        to: _selactLanguage1!.languageCode);
    // String textResult = await gt.trSimply(_textEditingControllerTrans.text,
    //     _selactLanguage1!.languageCode,
    //     _selactLanguage2!.languageCode);
    return gtransl.translations.text;
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkQuyen();
    _textEditingControllerTrans.text = 'touch the camera icon to start the scanner, and vice versa';
    safeState();
    //Constructing request object.
    // startScan();
//Call requestCameraAndStoragePermission API.
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final engine = MLTextLensEngine(controller: controller);
    engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SizedBox(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/background/bg3.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      Container(
                          child: MLTextLens(
                        textureId: textureId,
                        width: double.infinity,
                      )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: InkWell(
                            onTap: () {
                              if (start) {
                                final engine =
                                    MLTextLensEngine(controller: controller);
                                engine.release();
                              } else {
                                startScan();
                              }
                              setState(() {
                                start = !start;
                              });
                            },
                            child: Lottie.asset(
                                'assets/iconAnimation/camera.json',
                                animate: start),
                          ),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: BlurryContainer(
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide( //                   <--- left side
                                        color: Colors.white70,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Auto',
                                              style:
                                              TextStyle(color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius:
                                                BorderRadius.circular(30)),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          TextField(
                                            onChanged: (text) {
                                              getTranslate();
                                              setState(() {});
                                            },
                                            controller:
                                            _textEditingControllerTrans,
                                            cursorColor: Colors.white,
                                            decoration: null,
                                            enabled: _selactLanguage1 != null
                                                ? true
                                                : false,
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.white),
                                            maxLines: null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius:
                                                BorderRadius.circular(30)),
                                            padding: EdgeInsets.only(left: 10),
                                            child: DropdownButton(
                                              underline: const SizedBox(),
                                              menuMaxHeight: 300,
                                              hint: const Text(
                                                'Choose',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Inter'),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Inter'),
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
                                                final prefs = await SharedPreferences
                                                    .getInstance();
                                                for (int x = 0;
                                                x < getLanguages.length;
                                                x++) {
                                                  if (val?.name ==
                                                      getLanguages[x].name) {
                                                    // Save an integer value to 'counter' key.
                                                    await prefs.setInt('indexLang5', x);
                                                  }
                                                }

                                                setState(() {
                                                  _selactLanguage1 = val;
                                                });
                                              },
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: getTranslate(), // a previously-obtained Future<String> or null
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                              if (snapshot.hasData) {
                                                return SelectableLinkify(
                                                  text:
                                                  '${_textEditingControllerTrans.text != '' ? snapshot.data : 'touch the camera icon to start the scanner, and vice versa'}',
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'Inter',
                                                      color: Colors.white),
                                                );

                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                  'there seems to be a problem, wait a moment.'
                                                      ' if it takes too long please check the'
                                                      ' network connection,and '
                                                      'make sure you have selected the language'
                                                      ',or restart the app',
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

                                        ],
                                      ),
                                    )
                                  )
                                  )
                            ],
                          )),
                      blur: 5,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      elevation: 0,
                      color: Colors.black26,
                      padding: const EdgeInsets.all(8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    ));
  }

  void alertInfo() {
    Alert(
      context: context,
      title: 'info'.tr(),
      image: Lottie.asset('acssets/iconAnimation/search.json'),
      content: Container(
          child: Column(
        children: [
          Text(
            'Scan QR codes, barcodes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Scan QR automatically detects, magnifies, and recognizes barcodes from a distance, and is also able to scan a very small barcode in the same way. It works even in suboptimal situations, such as in dim light conditions or when the barcode is reflective, dirty, blurry, or printed on a cylindrical surface.',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
          Text(
            'Software integrated?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'The utility is only for users who use Huawei products, if you use another brand, please download HMS core to use this great tool.',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          )
        ],
      )),
      buttons: [
        DialogButton(
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }
}
