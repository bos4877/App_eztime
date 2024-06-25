import 'package:easy_localization/easy_localization.dart';
import 'package:eztime_app/Components/Custom/wrap_request_custom/wrap_request_custom.dart';
import 'package:eztime_app/Components/DiaLog/ButtonApprov/ButtonsTwoApprov.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ui_leave_status extends StatelessWidget {
  final bool isOpenButtons;
  final bool isOpentalling;
  final bool isTextbuttons;
  final String name;
  final String title_name;
  final String title_starttime;
  final String status;
  final String indentStatus;
  final String starttime;
  final String title_endtime;
  final String endtime;
  final String createtitle;
  final String createDate;
  final String title_Leavetype;
  final String Leavetype;
  final String title_detail;
  final String detail;
  final ValueChanged<bool>? onChang;
  final VoidCallback onPicture;
  final VoidCallback onApprove;
  final VoidCallback onCancel;
  ui_leave_status(
      {super.key,
      required this.isOpentalling,
      required this.isOpenButtons,
      required this.isTextbuttons,
      required this.title_name,
      required this.name,
      required this.status,
      required this.indentStatus,
      required this.title_starttime,
      required this.starttime,
      required this.title_endtime,
      required this.endtime,
      required this.createtitle,
      required this.createDate,
      required this.title_Leavetype,
      required this.Leavetype,
      required this.title_detail,
      required this.detail,
      required this.onChang,
      required this.onPicture,
      required this.onApprove,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 20),
            child: Material(
              elevation: 10,
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
                trailing: isTextbuttons
                    ? isOpentalling
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
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.red),
                                  ).tr()),
                            ],
                          )
                    : SizedBox(),
                title: Row(
                  children: [
                    Icon(
                      Bootstrap.file_earmark_post,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ).tr(),
                    SizedBox(
                      width: 20,
                    ),
                    //  !expanOpen ?
                    Text('$status',
                        style: TextStyle(
                            color: indentStatus == 'waiting'
                                ? Colors.amber
                                : indentStatus == 'approved'
                                    ? Colors.green
                                    : Colors.red)),
                  ],
                ),
                onExpansionChanged: onChang,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        wrap_body_list(icons: Icons.person,title: title_name, subtitle: name),
                        SizedBox(
                          height: 5,
                        ),
                        wrap_body_list(icons:Icons.assignment_add,title: createtitle, subtitle: createDate),
                      SizedBox(
                        height: 5,
                      ),
                        wrap_body_list(icons:Icons.add_alarm_rounded,
                            title: title_starttime, subtitle: starttime),
                        SizedBox(
                          height: 5,
                        ),
                          wrap_body_list(icons:Icons.add_alarm_rounded,
                            title: title_endtime, subtitle: endtime),
                        SizedBox(
                          height: 5,
                        ),
                        wrap_body_list(icons:Icons.event_note_rounded,
                            title: title_Leavetype, subtitle: Leavetype),
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
                        wrap_body_list(icons:Icons.article_outlined,title: title_detail, subtitle: detail),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      ],
                    ),
                  ),
                  isOpenButtons
                      ? ButtonTwoRequest(
                          onPressBtSucess: onApprove,
                          onPressBtNotsuc: onCancel,
                        )
                      : SizedBox(),
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
