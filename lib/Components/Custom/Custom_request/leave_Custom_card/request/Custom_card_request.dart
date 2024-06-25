import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/wrap_request_custom/wrap_request_custom.dart';
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
  final String createtitle;
  final String createDate;
  final String leavetitle;
  final String leaveType;
  final String detailtitle;
  final String detail;
  final Widget listApprov;
  final bool isOpentalling;
  final bool isOpenButtons;
  final bool isTextbuttons;
  final ValueChanged<bool>? onChang;
  final VoidCallback onEdite;
  final VoidCallback onCancel;
  final VoidCallback onPicture;
  final VoidCallback editeButtons;
  final VoidCallback cancelButtons;
  Custom_card_request(
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
      required this.createtitle,
      required this.createDate,
      required this.leavetitle,
      required this.leaveType,
      required this.detailtitle,
      required this.detail,
      required this.listApprov,
      required this.onPicture,
      required this.onChang,
      required this.onEdite,
      required this.onCancel,
      required this.editeButtons,
      required this.cancelButtons});
  // ListTileControlAffinity tal = ListTileControlAffinity.trailing;
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
              // initiallyExpanded: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              // controlAffinity: !isOpentalling ? tal : ListTileControlAffinity.leading,
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
                      wrap_body_list(icons:Icons.person,
                          title: employeetitle, subtitle: employeename),
                      SizedBox(
                        height: 5,
                      ),wrap_body_list(icons:Icons.assignment_add,title: createtitle, subtitle: createDate),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.add_alarm_rounded,
                          title: starttimetitle, subtitle: startdate),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.add_alarm_rounded,title: enddatetitle, subtitle: endDate),
                      SizedBox(
                        height: 5,
                      ),
                      wrap_body_list(icons:Icons.event_note_rounded,title: leavetitle, subtitle: leaveType),
                      SizedBox(
                        height: 5,
                      ),
                      
                     Row(
                          children: [
                            Icon(Icons.checklist_rounded),
                                SizedBox(width: 5,),
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
                      wrap_body_list(icons:Icons.article_outlined,title: detailtitle, subtitle: detail),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(Icons.assignment_ind_rounded),
                          Text('Leaverequestlist.Approval_authority').tr(),
                        ],
                      ),
                      listApprov,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.image_outlined,size: 20,),
                              SizedBox(width: 5,),
                              Text('Leaverequestlist.picture').tr(),
                            ],
                          ),
                          IconButton(
                              onPressed: onPicture,
                              icon: Icon(
                                Icons.image_outlined,
                                size: 40,
                              )),
                        ],
                      ),
                      isTextbuttons ? Divider() : SizedBox(),
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
