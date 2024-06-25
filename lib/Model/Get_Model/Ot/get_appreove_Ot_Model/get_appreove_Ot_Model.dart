class get_appreove_Ot_Model {
  List<DocList>? docList;

  get_appreove_Ot_Model({this.docList});

  get_appreove_Ot_Model.fromJson(Map<String, dynamic> json) {
    if (json['doc_list'] != null) {
      docList = <DocList>[];
      json['doc_list'].forEach((v) {
        docList!.add(new DocList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docList != null) {
      data['doc_list'] = this.docList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocList {
  String? docId;
  String? shiftDate;
  String? description;
  String? employeeName;
  String? statusApprove;
  String? otType;
  String? createDate;

  DocList(
      {this.docId,
      this.shiftDate,
      this.description,
      this.employeeName,
      this.statusApprove,
      this.otType,
      this.createDate});

  DocList.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    shiftDate = json['shift_date'];
    description = json['description'];
    employeeName = json['employee_name'];
    statusApprove = json['status_approve'];
    otType = json['ot_type'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['shift_date'] = this.shiftDate;
    data['description'] = this.description;
    data['employee_name'] = this.employeeName;
    data['status_approve'] = this.statusApprove;
    data['ot_type'] = this.otType;
    data['create_date'] = this.createDate;
    return data;
  }
}
