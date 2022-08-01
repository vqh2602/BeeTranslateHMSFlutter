import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:huawei_scan/hmsScanPermissions/HmsScanPermissions.dart';
import 'package:huawei_scan/hmsScanUtils/BuildBitmapRequest.dart';
import 'package:huawei_scan/hmsScanUtils/DefaultViewRequest.dart';
import 'package:huawei_scan/hmsScanUtils/HmsScanUtils.dart';
import 'package:huawei_scan/model/ScanResponse.dart';
import 'package:huawei_scan/utils/HmsScanTypes.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Color/colors.dart';
import '../../../../validators/validators.dart';



class ScanKitWithHMS extends StatefulWidget {
  const ScanKitWithHMS({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MyScanKitWithHMS();
  }
}

class _MyScanKitWithHMS extends State<ScanKitWithHMS> {
  DateTime? selectedDate = DateTime.now();
  Image? qrImage;
  TextEditingController catName = TextEditingController();

  GlobalKey _globalKey = GlobalKey();

  _saveScreen() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      //_toastInfo(result.toString());
      FlutterToastr.show("Save done!", context, duration: FlutterToastr.lengthShort, position:  FlutterToastr.bottom);

    }
  }



Future<void> checkQuyen()async {
  await HmsScanPermissions.requestCameraAndStoragePermissions();
  //Call hasCameraAndStoragePermission API.
  bool? permissionStatus = await HmsScanPermissions.hasCameraAndStoragePermission();
//Print status.
  //debugPrint(permissionStatus?.toString());
}

Future<void> startScan() async {
  DefaultViewRequest request = new DefaultViewRequest(scanType:HmsScanTypes.AllScanType);
  //Calling defaultView API with the request object.
  await HmsScanUtils.startDefaultView(request);
  //Obtain the result.
  ScanResponse response = await HmsScanUtils.startDefaultView(request);
//Print the result.
  print('scan kit: ${response.showResult}');
  Alert(
    context: context,
    title: 'Content',
    image: Lottie.asset('assets/iconAnimation/search.json'),
    content: Container(
        child: Column(
          children: [
            Text(
              'Contents of Qr code, barcode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50,),
            ((){
              if(hasValidUrl(response.showResult!)){
                return Linkify(
                  onOpen: (link) async {
                    if (await canLaunchUrl(Uri.parse(link.url))) {
                      await launchUrl(Uri.parse(link.url));
                    } else {
                      throw 'Could not launch $link';
                    }
                  },
                  text: response.showResult!,
                  style: TextStyle(color: Colors.black),
                  linkStyle: TextStyle(color: Colors.blueAccent),
                );
              }else { return SelectableLinkify(
                text: response.showResult!,
              );}
            }()),
            SizedBox(height: 50,),
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

 // await HmsScanUtils.disableLogger();

}

Future<void> createQR() async {
  final ByteData bytes = await rootBundle.load('assets/image/logo/logo.jpg');
  final Uint8List list = bytes.buffer.asUint8List();
  String data =
      '\n ${catName.text} '
      '\nCreate by: Bee Translate';

  //Constructing request object.
  BuildBitmapRequest request = new BuildBitmapRequest(
      content:data,
      width: 700,
      height: 700,
      type: HmsScanTypes.QRCode,
      margin: 1,
      bitmapColor: Colors.blueAccent,
      backgroundColor: Colors.white,
      qrLogo: list
  );
  //Call buildBitmap API with request object.
  Image image = (await HmsScanUtils.buildBitmap(request));
  setState(() {
    qrImage = image;
  });

}



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkQuyen();
    //Constructing request object.
    //createQR();

//Call requestCameraAndStoragePermission API.
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage("assets/image/background/u2.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Align(
                child: Container(
                  child: BlurryContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:[
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            'Scan QR',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Inter',
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: (){
                              startScan();
                            },
                            child: Lottie.asset('assets/iconAnimation/qr.json'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: InkWell(
                            onTap: (){
                              // createQR();
                              // showQR();
                              createQRAlert();
                            },
                            child: Text(
                              'Create QR',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Inter',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    blur: 5,
                    elevation: 0,
                    color: Colors.black26,
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                    padding: const EdgeInsets.all(8),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              )),
            ),

    );
  }



  void createQRAlert(){
    Alert(
      context: context,
      title: 'Create QR Code',
      //image: Lottie.asset('acssets/iconAnimation/search.json'),
      content: Container(
          margin: EdgeInsets.only(top: 10),
              width:MediaQuery.of(context).size.width*0.7,
              child: SingleChildScrollView(
                child:
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: catName,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        cursorColor: Colors.white,
                        decoration: null,
                        maxLines: null,
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'do not leave blank';
                          } else {
                            return null;
                          }
                        },
                        // decoration: const InputDecoration(
                        //   hintText: 'content',
                        //   labelText: 'content',
                        // ),
                      ),
                    ),
                      ),),
      buttons: [
        DialogButton(
          color:Colors.blueAccent,
          child: const Text(
            "Create",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            if(catName.text.isNotEmpty) {
              createQR();
              Future.delayed(const Duration(seconds: 1), () {
               showQR(null);
              });
            }else{
             showQR('The input data is incomplete, please do not leave the information blank');

            }
          },
        ),
      ],
    ).show();
  }
  void showQR(String? title) async {
    Alert(
      context: context,
      title: 'QR Code',
      //image: Lottie.asset('acssets/iconAnimation/search.json'),
      content:  RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.white,
          child: Container(
              margin: EdgeInsets.only(top: 0),
              child: title==null?Image(image: qrImage!.image,):Text(title)
          ),
        ),
      ),
      buttons: [
        DialogButton(
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // final teamDir = await getTemporaryDirectory();
            // final path = '${teamDir.path}/qr.jpg';
            // await GallerySaver.saveImage(path)
            _saveScreen();

          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }
}
