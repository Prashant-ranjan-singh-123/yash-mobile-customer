import 'package:eshop_multivendor/onboard/screenone.dart';
import 'package:eshop_multivendor/onboard/secondscreen.dart';
import 'package:eshop_multivendor/onboard/thirdscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Screen/Dashboard/Dashboard.dart';


class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;
  bool isLast=false;
  bool _isFirstTime = true;

  void skipButton(){
    not_running_first_time(context);
  }

  void doneButton(){
      not_running_first_time(context);
  }

  Future<void> not_running_first_time(BuildContext context) async {
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Dashboard(
      key: Dashboard.dashboardScreenKey,
    )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              currentPage = index;
              if(index==2) {
                isLast = true;
              }else{
                isLast=false;
              }
              setState(() {});
            },
            children: [
              screenone(),
              Secondscreen(),
              Thirdscreen(),
            ],
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isLast ? const Text('    ') :
                GestureDetector(
                  onTap:(){
                    skipButton();
                },
                  child: const Text('Skip',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(0, 168, 135, 1),
                      
                    ),),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const SwapEffect(
                    dotColor: Color.fromRGBO(0, 0, 0, 0.5),
                    activeDotColor: Color.fromRGBO(0, 168, 135, 0.7),
                    spacing: 8.0, // Adjust spacing between dots
                    dotHeight: 12.0, // Adjust the height of dots
                    dotWidth: 12.0, // Adjust the width of dots
                    paintStyle: PaintingStyle.fill, // Choose the style of dots
                  ),
                ),
                isLast ?
                GestureDetector(
                  onTap: (){
                    doneButton();
                  },
                  child: const Text('Done',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(0, 168, 135, 1),

                    ),
                  ),
                ):
                GestureDetector(
                  onTap: (){
                    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                  child: const Text('Next',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(0, 168, 135, 1),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}