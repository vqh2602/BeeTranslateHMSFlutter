import 'package:beetranslatehms/screen/home/home_VoiceTranslate/homeVoiceTranslate.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../Color/colors.dart';
import 'home_CameraTranslate/homeCameraTranslate.dart';
import 'home_TextTranslate/homeTextTranslate.dart';
import 'home_Utilities/homeUtilities.dart';



class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key, }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();
    return _MyHomeScreen();
  }

}
class _MyHomeScreen extends State<HomeScreen>{

  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text("Bee Translate",style: TextStyle(
      //   color: Colors.white
      // ),)),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        iconSize: 25,
        containerHeight: 70,
        curve: Curves.easeIn,
        backgroundColor: Colors.transparent,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem> [
          BottomNavyBarItem(
            icon: const Icon(Icons.wrap_text_sharp),
            title: const Text('Text'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.keyboard_voice),
            title: const Text('Voice'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.camera_alt),
            title: const Text(
              'Camera',
            ),
            activeColor: Colors.orange,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            title: const Text('Utilities'),
            activeColor: Colors.purple,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: Container(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: const <Widget>[
            HomeTextTranslateScreen(),
            HomeVoiceTranslateScreen(),
            MLTextWithHMSScreen(),
            HomeUtilitiesScreen()
          ],
        ),
      ),
    );
  }
}