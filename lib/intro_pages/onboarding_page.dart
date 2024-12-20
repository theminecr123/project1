import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:project1/intro_pages/intro_page1.dart';
import 'package:project1/intro_pages/intro_page2.dart';
import 'package:project1/intro_pages/intro_page3.dart';

class OnBoardingPage extends StatefulWidget{


  const OnBoardingPage({Key? key}): super(key: key);

    @override
    _OnBoardingPageState createState() => _OnBoardingPageState(); 
}


class _OnBoardingPageState extends State<OnBoardingPage>{

  PageController _pageController = PageController();
   @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); 

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),

            ],
          ),

          Container(
            alignment: Alignment(0, 0.5),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.white,
              ),
              
              
            )
          )
        ],
      ),
    );
  }
}
