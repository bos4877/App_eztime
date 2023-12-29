class company_Model {
  List<Results>? results;

  company_Model({this.results});

  company_Model.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? rowId;
  String? companyId;
  String? role;
  String? companyName;
  String? phone;
  String? email;
  String? inTime;
  String? outTime;
  int? timeBefore;
  int? timeAfter;
  String? locationId;
  int? active;
  List<Domain>? domain;

  Results(
      {this.rowId,
      this.companyId,
      this.role,
      this.companyName,
      this.phone,
      this.email,
      this.inTime,
      this.outTime,
      this.timeBefore,
      this.timeAfter,
      this.locationId,
      this.active,
      this.domain});

  Results.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    companyId = json['company_id'];
    role = json['role'];
    companyName = json['company_name'];
    phone = json['phone'];
    email = json['email'];
    inTime = json['in_time'];
    outTime = json['out_time'];
    timeBefore = json['time_before'];
    timeAfter = json['time_after'];
    locationId = json['location_id'];
    active = json['active'];
    if (json['domain'] != null) {
      domain = <Domain>[];
      json['domain'].forEach((v) {
        domain!.add(new Domain.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = this.rowId;
    data['company_id'] = this.companyId;
    data['role'] = this.role;
    data['company_name'] = this.companyName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['in_time'] = this.inTime;
    data['out_time'] = this.outTime;
    data['time_before'] = this.timeBefore;
    data['time_after'] = this.timeAfter;
    data['location_id'] = this.locationId;
    data['active'] = this.active;
    if (this.domain != null) {
      data['domain'] = this.domain!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Domain {
  String? domainId;
  String? domainName;

  Domain({this.domainId, this.domainName});

  Domain.fromJson(Map<String, dynamic> json) {
    domainId = json['domain_id'];
    domainName = json['domain_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain_id'] = this.domainId;
    data['domain_name'] = this.domainName;
    return data;
  }
}
