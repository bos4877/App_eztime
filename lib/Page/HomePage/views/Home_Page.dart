// import 'package:easy_localization/easy_localization.dart';
// import 'package:eztime_app/Components/Buttons/Button.dart';
// import 'package:eztime_app/Page/HomePage/controllers/HomePage_controller.dart';
// import 'package:eztime_app/Page/work/Set_work.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class Home_Page extends StatelessWidget {
//   final Home_Page_controller _controller = Get.put(Home_Page_controller());
//   final Home_Page_controller _Home_Page_controller = Get.find();
//   final Format_Date _PutFormat_Date = Get.put(Format_Date());
//   final Format_Date _Format_Date = Get.find<Format_Date>();
//    imagePage _putimage = Get.put(imagePage());
//    imagePage _timage = Get.find();

//   @override
//   Widget build(context) {
//     var changeLang = context.locale.languageCode;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('homepage.title').tr(),
//         elevation: 10,
//       ),
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           Container(
//             child: Container(
//               child: ListView(
//                 padding: EdgeInsets.all(5),
//                 children: [
//                   SizedBox(height: 90),
//                   SizedBox(height: 10.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.asset(
//                         'assets/icon_easytime/1x/icon_personal_available.png',
//                         scale: 20,
//                         color: Colors.blue,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         "homepage.username",
//                         style: TextStyle(fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ).tr(),
//                     ],
//                   ),
//                   Card(
//                     color: Colors.white,
//                     margin: EdgeInsets.symmetric(
//                       vertical: 5.0,
//                       horizontal: 30.0,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Obx(() {
//                             return Text(
//                               "${_putimage.image.value}",
//                               style:
//                                   TextStyle(fontSize: 13, color: Colors.black),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: ExpansionTile(
//                       initiallyExpanded: true,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       backgroundColor: Colors.white,
//                       title: Row(
//                         children: [
//                           Image.asset(
//                             'assets/icon_easytime/1x/icon_time.png',
//                             scale: 20,
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             'homepage.Check in-Check out',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ).tr(),
//                         ],
//                       ),
//                       children: [
//                         IntrinsicHeight(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   final imageController = imagePage();
//                                   imageController
//                                       .openImages(ImageSource.camera);
//                                 }, // Navigates to the imagePage()
//                                 child: Container(
//                                   child: Text('homepage.Check in',
//                                           style: TextStyle(
//                                               color: Colors.blue,
//                                               fontWeight: FontWeight.normal))
//                                       .tr(),
//                                 ),
//                               ),
//                               VerticalDivider(thickness: 2, endIndent: 5),
//                               TextButton(
//                                 onPressed: () async {},
//                                 child: Container(
//                                   child: Text('homepage.Check out',
//                                           style: TextStyle(
//                                               color: Colors.blue,
//                                               fontWeight: FontWeight.normal))
//                                       .tr(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: ExpansionTile(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       backgroundColor: Colors.white,
//                       title: Row(
//                         children: [Text('data')],
//                       ),
//                       onExpansionChanged: (expanded) {},
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextButton(
//                               onPressed: () {},
//                               child: Container(
//                                 width: double.infinity,
//                                 child: Row(
//                                   children: [],
//                                 ),
//                               ),
//                             ),
//                             Divider(),
//                             TextButton(
//                               onPressed: () {},
//                               child: Container(
//                                 width: double.infinity,
//                                 child: Row(
//                                   children: [],
//                                 ),
//                               ),
//                             ),
//                             Divider(),
//                             TextButton(
//                               onPressed: () {},
//                               child: Container(
//                                 width: double.infinity,
//                                 child: Row(
//                                   children: [],
//                                 ),
//                               ),
//                             ),
//                             Divider(),
//                             TextButton(
//                               onPressed: () {},
//                               child: Container(
//                                   width: double.infinity,
//                                   child: Row(
//                                     children: [],
//                                   )),
//                             ),
//                             // Obx(() => Text(_putimage.image.value)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Buttons(
//                     title: 'title',
//                     press: () {
//                       Obx(() => Text(_putimage.image.value.toString()),
//                       );
//                       print('image : ${_timage.image.value}');
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
