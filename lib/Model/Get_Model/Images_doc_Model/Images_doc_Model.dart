class Images_doc_Model {
  String? img;

  Images_doc_Model({this.img});

  Images_doc_Model.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
