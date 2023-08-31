import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
Future load()async{
  EasyLoading.instance
  ..indicatorType = EasyLoadingIndicatorType.threeBounce
  ..loadingStyle = EasyLoadingStyle.custom
  ..indicatorSize = 30.0
  ..radius = 15.0
  ..progressColor = Colors.transparent
  ..backgroundColor = Colors.white
  ..indicatorColor = Colors.orange[400]
  ..textColor = Colors.orange[400]
  ..fontSize = 17.5
  ..maskColor = Colors.black54
  ..userInteractions = true
  ..dismissOnTap = false;
   

}
Future _show()async{
EasyLoading.show(status: 'loading...', maskType:EasyLoadingMaskType.none ,);
}

  @override
  void initState() {
    _show();
    // TODO: implement initState
    super.initState();
  }
    @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     EasyLoading.init();
    return Container();
  }

}
