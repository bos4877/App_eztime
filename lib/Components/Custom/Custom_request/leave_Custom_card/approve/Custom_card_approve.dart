import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:flutter/material.dart';

class Custom_card_request extends StatelessWidget {
  final String employeename;
  final String employeetitle;
  final String status;
  final String indentStatus;
  final String starttimetitle;
  final String startdate;
  final String enddatetitle;
  final String endDate;
  final String leavetitle;
  final String leaveType;
  final String detailtitle;
  final String detail;
  final Widget listApprov;
  final bool isOpentalling;
  final bool isOpenButtons;
  final ValueChanged<bool>? onChang;
  final VoidCallback onApprove;
  final VoidCallback onCancel;
  final VoidCallback onPicture;
  final VoidCallback editeButtons;
  final VoidCallback cancelButtons;
  Custom_card_request(
      {super.key,
      required this.employeetitle,
      required this.employeename,
      required this.status,
      required this.indentStatus,
      required this.starttimetitle,
      required this.startdate,
      required this.enddatetitle,
      required this.endDate,
      required this.leavetitle,
      required this.leaveType,
      required this.detailtitle,
      required this.detail,
      required this.listApprov,
      required this.isOpentalling,
      required this.isOpenButtons,
      required this.onPicture,
      required this.onChang,
      required this.onApprove,
      required this.onCancel,
      required this.editeButtons,
      required this.cancelButtons});
  ListTileControlAffinity tal = ListTileControlAffinity.trailing;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.all(8),
        child: Material(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0), side: BorderSide.none),
          child: ExpansionTile(
            maintainState: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            trailing: isOpentalling
                ? SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Wrap(
                    children: [
                      TextButton(
                          onPressed: onApprove,
                          child: Text(
                            'buttons.approve',
                            style: TextStyle(fontSize: 9),
                          ).tr()),
                      TextButton(
                          onPressed: onCancel,
                          child: Text(
                            'buttons.cancle',
                            style: TextStyle(fontSize: 9, color: Colors.red),
                          ).tr()),
                    ],
                  ),

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
                    Wrap(
                      children: [
                        Text(
                          employeename,
                          style: TextStyle(fontSize: 14),
                        ).tr(),
                        Text(employeename),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        Text(starttimetitle).tr(),
                        Text(startdate),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        Text(leaveType).tr(),
                        Text(leaveType),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        Text(detailtitle).tr(),
                        Text(detail),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        Text('Approve_leave.status').tr(),
                        Text(' $status',
                            style: TextStyle(
                                color: indentStatus == 'waiting'
                                    ? Colors.amber
                                    : indentStatus == 'approved'
                                        ? Colors.green
                                        : Colors.red)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Leaverequestlist.picture').tr(),
                        IconButton(
                            onPressed: () async {},
                            icon: Icon(
                              Icons.image_outlined,
                              size: 40,
                            )),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
              ButtonTwoAppprove(
                  onPressBtSucess: onApprove, onPressBtNotsuc: onCancel),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
