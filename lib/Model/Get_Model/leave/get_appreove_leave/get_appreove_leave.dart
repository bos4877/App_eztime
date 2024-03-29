class get_appreove_leave_Model {
  List<DocList>? docList;

  get_appreove_leave_Model({this.docList});

  get_appreove_leave_Model.fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? employeeName;
  String? statusAprrove;
  String? leaveType;
  String? createDate;
  String? leaveDescription;

  DocList(
      {this.docId,
      this.description,
      this.employeeName,
      this.statusAprrove,
      this.leaveType,
      this.createDate,
      this.leaveDescription});

  DocList.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    description = json['description'];
    employeeName = json['employee_name'];
    statusAprrove = json['status_aprrove'];
    leaveType = json['leave_type'];
    createDate = json['create_date'];
    leaveDescription = json['leave_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['description'] = this.description;
    data['employee_name'] = this.employeeName;
    data['status_aprrove'] = this.statusAprrove;
    data['leave_type'] = this.leaveType;
    data['create_date'] = this.createDate;
    data['leave_description'] = this.leaveDescription;
    return data;
  }
}
