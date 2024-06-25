import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Simple extends StatefulWidget {
  const Simple({super.key});

  @override
  State<Simple> createState() => _SimpleState();
}

class _SimpleState extends State<Simple> {
  List<TargetFocus> targets = [];
  GlobalKey keyTarget = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark!.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
        actions: [
          Container(
            key: keyTarget,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Is this"),
              ),
              const PopupMenuItem(
                child: Text("What"),
              ),
              const PopupMenuItem(
                child: Text("You Want?"),
              ),
            ],
          )
        ],
      ),
      // body: targets.,
    );
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.grey,
      hideSkip: true,
      showSkipInLastTarget: false,
      // textSkip: "SKIP",
      paddingFocus: 5,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyTarget,
        contents: [
          TargetContent(
            builder: (context, controller) {
              return   Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "กรุณาเพิ่มรูปภาพก่อนเข้างาน",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }
}
