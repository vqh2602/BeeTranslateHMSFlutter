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
  final controller = MLTextLensController(
    // Set the transaction type
      transaction: TextTransaction.text,
      // Set the lens to front or back
      lensType: MLTextLensController.backLens);

// Create a lens engine object and specify the controller.
  List<TextBlock> listTB = [];
  bool start = true;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkQuyen();
    //Constructing request object.
    startScan();
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
                          flex: 7,
                          child: Container(
                              child: MLTextLens(
                                textureId: textureId,
                                width: double.infinity,
                              )
                          )),
                      Expanded(
                        flex: 3,
                        child:Container(
                          padding: EdgeInsets.all(10),
                          child: BlurryContainer(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 5),
                              child: SingleChildScrollView(
                                child: SelectableLinkify(
                                  text:
                                  '${listTB.length > 0 ? listTB[0].stringValue : 'scan text'}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                      color: Colors.white),
                                ),
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
                        )

                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
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
                            child: Lottie.asset('assets/iconAnimation/camera.json',
                                animate: start),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          )
    );
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
