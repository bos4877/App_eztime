class get_leavelist_one_Model {
  List<Data>? data;

  get_leavelist_one_Model({this.data});

  get_leavelist_one_Model.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? docId;
  String? description;
  String? statusAprrove;
  String? startDate;
  String? endDate;
  String? leaveType;
  String? file;
  String? employeeName;
  String? createDate;
  List<DocLeaveApprove>? docLeaveApprove;

  Data(
      {this.docId,
      this.description,
      this.statusAprrove,
      this.startDate,
      this.endDate,
      this.leaveType,
      this.file,
      this.employeeName,
      this.createDate,
      this.docLeaveApprove});

  Data.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    description = json['description'];
    statusAprrove = json['status_aprrove'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    leaveType = json['Leave_type'];
    file = json['file'];
    employeeName = json['employee_name'];
    createDate = json['create_date'];
    if (json['Doc_Leave_Approve'] != null) {
      docLeaveApprove = <DocLeaveApprove>[];
      json['Doc_Leave_Approve'].forEach((v) {
        docLeaveApprove!.add(new DocLeaveApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['description'] = this.description;
    data['status_aprrove'] = this.statusAprrove;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['Leave_type'] = this.leaveType;
    data['file'] = this.file;
    data['employee_name'] = this.employeeName;
    data['create_date'] = this.createDate;
    if (this.docLeaveApprove != null) {
      data['Doc_Leave_Approve'] =
          this.docLeaveApprove!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocLeaveApprove {
  String? status;
  String? employeeName;
  String? updateDate;

  DocLeaveApprove({this.status, this.employeeName, this.updateDate});

  DocLeaveApprove.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    employeeName = json['employee_name'];
    updateDate = json['update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['employee_name'] = this.employeeName;
    data['update_date'] = this.updateDate;
    return data;
  }
}
