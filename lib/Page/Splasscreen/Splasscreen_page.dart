import 'package:eztime_app/Page/Splasscreen/intro_screen/intro_pageOne.dart';
import 'package:eztime_app/Page/Splasscreen/intro_screen/intro_pageThree.dart';
import 'package:eztime_app/Page/Splasscreen/intro_screen/intro_pageTwo.dart';
import 'package:eztime_app/Page/login/SetDomain_Page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class splass_screen extends StatefulWidget {
  const splass_screen({super.key});

  @override
  State<splass_screen> createState() => _splass_screenState();
}

class _splass_screenState extends State<splass_screen> {
  PageController _pagecontroller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pagecontroller,
            onPageChanged: (value) {
              setState(() {
                onLastPage = (value == 2);
              });
            },
            children: [intro_page_one(), intro_page_two(), intro_page_three()],
          ),
          Container(
            alignment: Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _pagecontroller.jumpToPage(2);
                    },
                    child: Text(
                      'skip',
                      style: TextStyle(color: Colors.white),
                    )),
                ///////////////////////////////////////
                SmoothPageIndicator(
                    controller: _pagecontroller,
                    count: 3,
                    effect: ScrollingDotsEffect(
                      activeDotColor: Colors.blueGrey.shade700,
                      dotColor: Colors.white,
                      activeStrokeWidth: 2.6,
                      activeDotScale: 1.3,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 10,
                      dotHeight: 12,
                      dotWidth: 12,
                    )),
                ////////////////////////////////////////////////////
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Domain_Set_Page(),
                              ));
                        },
                        child: Text(
                          'done',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pagecontroller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          'next',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final colors = const [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];
