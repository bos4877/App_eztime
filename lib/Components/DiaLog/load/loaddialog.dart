import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Center(

                child: CircularProgressIndicator(
                  // strokeWidth: 10,
                  backgroundColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                ),
              ),
    );
  }
}
