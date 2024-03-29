import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
class CustomRow_checkin extends StatelessWidget {
  final String title;
  final String leading;
  const CustomRow_checkin({super.key,required this.title,required this.leading});

  @override
  Widget build(BuildContext context) {
    return  Row(
                                        children: [
                                          Text(
                                            title.tr(),
                                            style: TextStyle(color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            leading.tr(),
                                            style: TextStyle(color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      );
  }
}