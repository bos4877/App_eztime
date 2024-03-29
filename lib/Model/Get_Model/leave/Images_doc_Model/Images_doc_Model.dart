class Images_doc_Model_leavelist {
  String? img;

  Images_doc_Model_leavelist({this.img});

  Images_doc_Model_leavelist.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
