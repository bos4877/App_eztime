// ignore_for_file: prefer_conditional_assignment
import 'package:connectivity_plus/connectivity_plus.dart';

class Utility {

  static Utility? utility;

  static Utility? getInstance() {
    if(utility == null){
      utility = Utility();
    }

    return utility;
  }

  // สร้างฟังก์ชันสำหรับเช็คการเชื่อมต่อ Network
  Future<String> checkNetwork() async {
    // เช็คว่ามีการเชื่อมต่อ Internet ไว้หรือไม่
    var checkNetwork = await Connectivity().checkConnectivity();
    
    if(checkNetwork == ConnectivityResult.mobile){
      return 'mobile';
    }else if(checkNetwork == ConnectivityResult.wifi){
      return 'wifi';
    }else if(checkNetwork == ConnectivityResult.ethernet){
      return 'ethernet';
    }else if(checkNetwork == ConnectivityResult.none){
      return 'none';
    }else{
      return 'none';
    }
  }

}