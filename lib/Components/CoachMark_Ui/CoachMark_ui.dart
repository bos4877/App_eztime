import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CoachMark_ui_complonance extends StatefulWidget {
  final String text;
  final String Skip;
  final String Next;
  final void Function()? onSkip;
  final void Function()? onNext;
  const CoachMark_ui_complonance(
      {super.key,
      required this.text,
      this.Next = 'homepage.Push',
      this.Skip = 'homepage.Skip',
      this.onSkip,
      this.onNext});

  @override
  State<CoachMark_ui_complonance> createState() =>
      _CoachMark_ui_complonanceState();
}

class _CoachMark_ui_complonanceState extends State<CoachMark_ui_complonance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.text.tr()),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: widget.onSkip, child: Text(widget.Skip).tr()),
              SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text(widget.Next,style: TextStyle(color: Colors.white),).tr(),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor)),
              )
            ],
          )
        ],
      ),
    );
  }
}
