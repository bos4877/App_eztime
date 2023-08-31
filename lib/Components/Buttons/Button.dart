import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  String title;
  VoidCallback press;
  Buttons({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 40,
      child: ElevatedButton(
          style: TextButton.styleFrom(
            side: BorderSide(color: Color(0xFF1976D2)),
            backgroundColor: Color(0xFF1976D2),
            
            // shape:
            
                // RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            primary: Colors.black,
            foregroundColor: Colors.blue,
            // surfaceTintColor: Colors.amber,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          onPressed: press),
    );
  }
}
