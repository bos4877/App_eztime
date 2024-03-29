class get_doc_Ot_list_one_model {
  List<Data>? data;

  get_doc_Ot_list_one_model({this.data});

  get_doc_Ot_list_one_model.fromJson(Map<String, dynamic> json) {
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
  String? statusApprove;
  String? startDate;
  String? endDate;
  String? otType;
  String? otId;
  String? shiftDate;
  String? employeeName;
  String? createDate;
  List<DocOtApprove>? docOtApprove;

  Data(
      {this.docId,
      this.description,
      this.statusApprove,
      this.startDate,
      this.endDate,
      this.otType,
      this.otId,
      this.shiftDate,
      this.employeeName,
      this.createDate,
      this.docOtApprove});

  Data.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    description = json['description'];
    statusApprove = json['status_approve'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    otType = json['ot_type'];
    otId = json['ot_id'];
    shiftDate = json['shift_date'];
    employeeName = json['employee_name'];
    createDate = json['create_date'];
    if (json['Doc_Ot_Approve'] != null) {
      docOtApprove = <DocOtApprove>[];
      json['Doc_Ot_Approve'].forEach((v) {
        docOtApprove!.add(new DocOtApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['description'] = this.description;
    data['status_approve'] = this.statusApprove;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['ot_type'] = this.otType;
    data['ot_id'] = this.otId;
    data['shift_date'] = this.shiftDate;
    data['employee_name'] = this.employeeName;
    data['create_date'] = this.createDate;
    if (this.docOtApprove != null) {
      data['Doc_Ot_Approve'] =
          this.docOtApprove!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocOtApprove {
  String? status;
  String? employeeName;
  String? updateDate;

  DocOtApprove({this.status, this.employeeName, this.updateDate});

  DocOtApprove.fromJson(Map<String, dynamic> json) {
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
