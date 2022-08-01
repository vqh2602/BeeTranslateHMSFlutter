

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:huawei_safetydetect/huawei_safetydetect.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../validators/validators.dart';


class SafeKitHMS extends StatefulWidget {
  const SafeKitHMS({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MyMLKitHMS();
  }
}

class _MyMLKitHMS extends State<SafeKitHMS> {
  DateTime? selectedDate = DateTime.now();
  String? appId;
  TextEditingController textEditingControllerUrl = TextEditingController();
  String urlcheck='assets/iconAnimation/blackcat.json';
   String urlRessul = 'Meow Meow . . .';

  // getAppId() async {
  //   String appID = await SafetyDetect.getAppID;
  //   setState(() {
  //     appId = appID;
  //   });
  // }
  //
  // checkSysIntegrity() async {
  //   Random secureRandom = Random.secure();
  //   List<int> randomIntegers = [];
  //   for (var i = 0; i < 24; i++) {
  //     randomIntegers.add(secureRandom.nextInt(255));
  //   }
  //   Uint8List nonce = Uint8List.fromList(randomIntegers);
  //   try {
  //     String result = await SafetyDetect.sysIntegrity(nonce, appId!);
  //     List<String> jwsSplit = result.split(".");
  //     String decodedText = utf8.decode(base64Url.decode(jwsSplit[1]));
  //     //showToast("SysIntegrityCheck result is: $decodedText");
  //   } on PlatformException catch (e) {
  //     //showToast("Error occured while getting SysIntegrityResult. Error is : $e");
  //   }
  // }

  // void urlCheck1() async {
  //   List<UrlThreatType> threatTypes = [
  //     UrlThreatType.malware,
  //     UrlThreatType.phishing
  //   ];
  //
  //   List<UrlCheckThreat> urlCheckResults =
  //   await SafetyDetect.urlCheck(
  //       'http://ctms.fithou.net.vn/', await SafetyDetect.getAppID, threatTypes);
  //  // print('ket qua: '+ await urlCheckResults[0].getUrlThreatType.toString());
  //
  //   if (await urlCheckResults.length == 0) {
  //     //showToast("No threat is detected for the URL");
  //   } else {
  //     urlCheckResults.forEach((element) {
  //       print("${element.getUrlThreatType} is detected on the URL");
  //     });
  //   }
  // }

  void urlCheck(String url) async {
    if(hasValidUrl(url)){
      String concernedUrl = url;
      String urlCheckRes = "";
      List<UrlThreatType> threatTypes = [
        UrlThreatType.malware,
        UrlThreatType.phishing];
      List<UrlCheckThreat> urlCheckResults =
      await SafetyDetect.urlCheck(concernedUrl , await SafetyDetect.getAppID, threatTypes);
      if (urlCheckResults.length == 0) {
        urlCheckRes = "No threat is detected for the URL: $concernedUrl";
        print('an toan');
        setState(() {
         urlcheck = 'assets/iconAnimation/guard.json';
         urlRessul = 'Website: $url seems safe';
        });
      } else {
        urlCheckResults.forEach((element) {
          urlCheckRes += "${element.getUrlThreatType} is detected on the URL: $concernedUrl";
          print('nguy hiem');
          setState(() {
           urlcheck = 'assets/iconAnimation/warning.json';
           urlRessul = 'Website: $url is malware or phishing';
          });
        });
      }
      print(urlCheckRes);
    }else{
      print('sai url');
      setState(() {
        urlcheck='assets/iconAnimation/blackcat.json';
        urlRessul = 'Meow Meow . . .';
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAppId();
    setState(() {
      textEditingControllerUrl.text = 'http://';
    });
    //Constructing request object.

//Call requestCameraAndStoragePermission API.
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage("assets/image/background/u5.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Align(
                child: Container(
                  child: BlurryContainer(
                    //color: Colors.white30,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20,),
                            Container(
                              child: TextFormField(
                                controller: textEditingControllerUrl,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'not empty';
                                  } else if (!hasValidUrl(value)) {
                                    return 'enter the correct format http://url.xyz/';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Ionicons.logo_web_component,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white)),
                                  labelText: 'enter url starting with http://',
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),

                            InkWell(
                              onTap: (){
                                urlCheck(textEditingControllerUrl.text);
                              },
                              child:  Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  'Check url',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                      color: Colors.white),
                                ),
                              ),),

                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:<Widget> [
                                  Padding(padding: EdgeInsets.all(20),
                                    child: Lottie.asset(urlcheck,width: double.infinity*0.7,fit: BoxFit.fill),),
                                  SelectableLinkify(
                                    text: urlRessul,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp,color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20,)

                          ],
                        ),
                      ),
                    ),
                    blur: 5,
                    elevation: 0,
                    color: Colors.black26,
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(8),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
          )
    );
  }




}
