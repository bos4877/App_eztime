

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService extends StatefulWidget {
  const NotificationService({super.key});

  @override
  State<NotificationService> createState() => _NotificationServiceState();
}

class _NotificationServiceState extends State<NotificationService> {

  var message;
  var channelId = "1000";
  var channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  var channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  
  get flutterLocalNotificationsPlugin => null;

    @override
  initState() {
    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) {
    //   print("onDidReceiveLocalNotification called.");
    // });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        //  iOS:initializationSettingsIOS
         );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    super.initState();
  }

 sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 
        importance: Importance.max, priority: Priority.high);
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics, 
        // iOSPlatformChannelSpecifics
        );

    await flutterLocalNotificationsPlugin.show(111, 'Hello, benznest.',
        'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification();
        },
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
    );
  }
}