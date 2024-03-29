class get_addtime_Model {
  List<Data>? data;

  get_addtime_Model({this.data});

  get_addtime_Model.fromJson(Map<String, dynamic> json) {
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
  String? shiftDate;
  String? employeeName;
  String? createDate;
  List<DocAddtimeApprove>? docAddtimeApprove;

  Data(
      {this.docId,
      this.description,
      this.statusApprove,
      this.shiftDate,
      this.employeeName,
      this.createDate,
      this.docAddtimeApprove});

  Data.fromJson(Map<String, dynamic> json) {
    docId = json['doc_id'];
    description = json['description'];
    statusApprove = json['status_approve'];
    shiftDate = json['shift_date'];
    employeeName = json['employee_name'];
    createDate = json['create_date'];
    if (json['Doc_Addtime_Approve'] != null) {
      docAddtimeApprove = <DocAddtimeApprove>[];
      json['Doc_Addtime_Approve'].forEach((v) {
        docAddtimeApprove!.add(new DocAddtimeApprove.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_id'] = this.docId;
    data['description'] = this.description;
    data['status_approve'] = this.statusApprove;
    data['shift_date'] = this.shiftDate;
    data['employee_name'] = this.employeeName;
    data['create_date'] = this.createDate;
    if (this.docAddtimeApprove != null) {
      data['Doc_Addtime_Approve'] =
          this.docAddtimeApprove!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocAddtimeApprove {
  String? status;
  String? employeeName;
  String? updateDate;

  DocAddtimeApprove({this.status, this.employeeName, this.updateDate});

  DocAddtimeApprove.fromJson(Map<String, dynamic> json) {
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
