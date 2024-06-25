class Profile_Model {
  EmployData? employData;

  Profile_Model({this.employData});

  Profile_Model.fromJson(Map<String, dynamic> json) {
    employData = json['employ_data'] != null
        ? new EmployData.fromJson(json['employ_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employData != null) {
      data['employ_data'] = this.employData!.toJson();
    }
    return data;
  }
}

class EmployData {
  String? employeeRole;
  String? employeeNo;
  String? nickname;
  String? idCard;
  String? firstName;
  String? lastName;
  String? birthDay;
  String? phone;
  String? email;
  String? sex;
  String? nationality;
  String? bankName;
  String? bankNo;
  String? status;
  String? employeeType;
  String? salary;
  String? startedDate;
  String? passedDate;
  String? vatId;
  String? image;

  EmployData(
      {this.employeeRole,
      this.employeeNo,
      this.nickname,
      this.idCard,
      this.firstName,
      this.lastName,
      this.birthDay,
      this.phone,
      this.email,
      this.sex,
      this.nationality,
      this.bankName,
      this.bankNo,
      this.status,
      this.employeeType,
      this.salary,
      this.startedDate,
      this.passedDate,
      this.vatId,
      this.image});

  EmployData.fromJson(Map<String, dynamic> json) {
    employeeRole = json['employee_role'];
    employeeNo = json['employee_no'];
    nickname = json['nickname'];
    idCard = json['idCard'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthDay = json['birth_day'];
    phone = json['phone'];
    email = json['email'];
    sex = json['sex'];
    nationality = json['nationality'];
    bankName = json['bank_name'];
    bankNo = json['bank_no'];
    status = json['status'];
    employeeType = json['employee_type'];
    salary = json['salary'];
    startedDate = json['started_date'];
    passedDate = json['passed_date'];
    vatId = json['vat_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_role'] = this.employeeRole;
    data['employee_no'] = this.employeeNo;
    data['nickname'] = this.nickname;
    data['idCard'] = this.idCard;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['birth_day'] = this.birthDay;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['sex'] = this.sex;
    data['nationality'] = this.nationality;
    data['bank_name'] = this.bankName;
    data['bank_no'] = this.bankNo;
    data['status'] = this.status;
    data['employee_type'] = this.employeeType;
    data['salary'] = this.salary;
    data['started_date'] = this.startedDate;
    data['passed_date'] = this.passedDate;
    data['vat_id'] = this.vatId;
    data['image'] = this.image;
    return data;
  }
}
