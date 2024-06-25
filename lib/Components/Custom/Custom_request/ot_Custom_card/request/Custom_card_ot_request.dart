import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/wrap_request_custom/wrap_request_custom.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:flutter/material.dart';

class Custom_card_ot extends StatelessWidget {
  final String employeename;
  final String employeetitle;
  final String status;
  final String indentStatus;
  final String starttimetitle;
  final String startdate;
  final String enddatetitle;
  final String endDate;
  final String ottitle;
  final String otType;
  final String detailtitle;
  final String detail;
  final Widget listApprov;
  final bool isOpentalling;
  final bool isOpenButtons;
  final bool isTextbuttons;
  final ValueChanged<bool>? onChang;
  final VoidCallback onEdite;
  final VoidCallback onCancel;
  final VoidCallback editeButtons;
  final VoidCallback cancelButtons;
  Custom_card_ot(
      {super.key,
      required this.isOpentalling,
      required this.isOpenButtons,
      required this.isTextbuttons,
      required this.employeetitle,
      required this.employeename,
      required this.status,
      required this.indentStatus,
      required this.starttimetitle,
      required this.startdate,
      required this.enddatetitle,
      required this.endDate,
      required this.ottitle,
      required this.otType,
      required this.detailtitle,
      required this.detail,
      required this.listApprov,
      required this.onChang,
      required this.onEdite,
      required this.onCancel,
      required this.editeButtons,
      required this.cancelButtons});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Material(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
                side: BorderSide.none),
            child: ExpansionTile(
              maintainState: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              trailing: isTextbuttons
                  ? isOpentalling
                      ? SizedBox(
                          width: 0,
                          height: 0,
                        )
                      : Wrap(
                          children: [
                            TextButton(
                                onPressed: onEdite,
                                child: Text(
                                  'buttons.edite',
                                  style: TextStyle(fontSize: 9),
                                ).tr()),
                            TextButton(
                                onPressed: onCancel,
                                child: Text(
                                  'buttons.cancle',
                                  style:
                                      TextStyle(fontSize: 9, color: Colors.red),
                                ).tr()),
                          ],
                        )
                  : SizedBox(),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeename,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ).tr(),
                  SizedBox(
                    height: 8,
                  ),
                  //  !expanOpen ?
                  Text(status,
                      style: TextStyle(
                          color: indentStatus == 'waiting'
                              ? Colors.amber
                              : indentStatus == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 14)),
                ],
              ),
              onExpansionChanged: onChang,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5),
                      wrap_body_list(icons:Icons.cabin,
                          title: employeetitle, subtitle: employeename),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.cabin,
                          title: starttimetitle, subtitle: startdate),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.cabin,title: enddatetitle, subtitle: endDate),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.cabin,title: ottitle, subtitle: otType),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.cabin,title: detailtitle, subtitle: detail),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('Leaverequestlist.status').tr(),
                          SizedBox(
                            width: 5,
                          ),
                          Text(status,
                              style: TextStyle(
                                  color: indentStatus == 'waiting'
                                      ? Colors.amber
                                      : indentStatus == 'approved'
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 14)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Leaverequestlist.Approval_authority').tr(),
                      listApprov,
                     isTextbuttons ? Divider(): SizedBox(),
                      isOpenButtons
                          ? ButtonTwoRequest(
                              onPressBtSucess: editeButtons,
                              onPressBtNotsuc: cancelButtons,
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
