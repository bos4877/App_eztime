class approve_addtime_model {
  List<DocList>? docList;

  approve_addtime_model({this.docList});

  approve_addtime_model.fromJson(Map<String, dynamic> json) {
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
  String? statusAprrove;
  String? createDate;

  DocList(
      {this.docId,
      this.shiftDate,
      this.description,
      this.employeeName,
      this.statusAprrove,
      this.createDate});

  DocList.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    shiftDate = json['shift_date'];
    description = json['description'];
    employeeName = json['employee_name'];
    statusAprrove = json['status_aprrove'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['shift_date'] = this.shiftDate;
    data['description'] = this.description;
    data['employee_name'] = this.employeeName;
    data['status_aprrove'] = this.statusAprrove;
    data['create_date'] = this.createDate;
    return data;
  }
}
