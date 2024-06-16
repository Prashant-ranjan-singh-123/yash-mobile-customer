import 'dart:async';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/IntroSlider/Intro_Slider.dart';
import 'package:eshop_multivendor/widgets/applogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/String.dart';
import '../../onboard/onboardingscreen.dart';
import '../../widgets/desing.dart';
import '../../widgets/systemChromeSettings.dart';
import '../Dashboard/Dashboard.dart';

//splash screen of app
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool from = false;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
    //setToken();
    initializeAnimationController();
    startTime();
    super.initState();
  }

/*   void setToken() async {
    FirebaseMessaging.instance.getToken().then(
      (token) async {
        SettingProvider settingsProvider =
            Provider.of<SettingProvider>(context, listen: false);

        String getToken = await settingsProvider.getPrefrence(FCMTOKEN) ?? '';

        if (token != getToken && token != null) {
          context
              .read<PushNotificationProvider>()
              .registerToken(token, context);
        }
      },
    );
  } */

  void initializeAnimationController() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<HomePageProvider>()
          ..setAnimationController(navigationContainerAnimationController)
          ..setBottomBarOffsetToAnimateController(
              navigationContainerAnimationController)
          ..setAppBarOffsetToAnimateController(
              navigationContainerAnimationController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/png/bgfinal.jpg"),
                fit: BoxFit.fill,

              ),
            ),
            child: Container(
              padding: EdgeInsets.all(90),
              child: Image(image: AssetImage("assets/images/png/yashmobile.jpeg")),
            ),
          ),
          Image.asset(
            DesignConfiguration.setPngPath('doodle'),
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }


  startTime() async {
    context
        .read<HomePageProvider>()
        .getSections(isnotify: false, context: context);
    var duration = const Duration(seconds: 2);
    return Timer(duration, checkAndTriggerFunction);
  }

  Future<void> running_first_time() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('running_first_time', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(const OnBoardScreen())));
  }

  Future<void> not_running_first_time(BuildContext context) async {
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Dashboard(
      key: Dashboard.dashboardScreenKey,
    )),
    );
  }

  Future<void> checkAndTriggerFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('running_first_time') ?? true;
    if (!boolValue) {
      not_running_first_time(context);
    } else {
      prefs.setBool('running_first_time', false);
      running_first_time();
    }
  }

  @override
  void dispose() {
    if (from) {
      SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    }
    super.dispose();
  }
}
