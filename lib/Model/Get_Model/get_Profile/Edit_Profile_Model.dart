class Edit_Profile_Model {
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

  Edit_Profile_Model(
      {this.firstName,
      this.lastName,
      this.birthDay,
      this.phone,
      this.email,
      this.sex,
      this.nationality,
      this.bankName,
      this.bankNo,
      this.status});

  Edit_Profile_Model.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
