import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyVersionAppScreen();
  }
}

class _MyVersionAppScreen extends State<VersionAppScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    print(info.version);
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'vqh2602@gmail.com',
      query: encodeQueryParameters(
          <String, String>{'subject': 'Thông báo lỗi ứng dụng meowassistan'}),
    );
    Future<void> _launchUrl(Uri url) async {
      if (!await launchUrl(
        url,
      )) {
        throw 'Could not launch $url';
      }
    }

    Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication))
        throw 'Could not launch $url';
    }

    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/image/background/u6.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              child: BlurryContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'App name: ${_packageInfo.appName}'
                      '\n------'
                      '\n Version: ${_packageInfo.version}'
                      '\n------'
                      '\nMessage: The application is a small product of mine in the process of learning and developing towards community purposes. However, in the application development process, there will be some problems and minor errors. And I am still trying to fix it. Thank you for using this app!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Contact & report bugs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _launchUrl(emailLaunchUri);
                          },
                          child: Icon(
                            Icons.mail,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchInBrowser(
                                Uri.parse('https://www.facebook.com/vqhapps'));
                          },
                          child: Icon(
                            Icons.facebook,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchInBrowser(
                                Uri.parse('https://www.instagram.com/vqh.26/'));
                          },
                          child: Icon(
                            Ionicons.logo_instagram,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                blur: 5,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                elevation: 0,
                color: Colors.black12,
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
