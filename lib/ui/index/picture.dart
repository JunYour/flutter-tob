class HomePicture {
  String imgurl;
  String linkurl;
  String linktype;

  HomePicture({this.imgurl, this.linkurl, this.linktype});

  HomePicture.fromJson(Map<String, dynamic> json) {
    imgurl = json['imgurl'];
    linkurl = json['linkurl'];
    linktype = json['linktype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgurl'] = this.imgurl;
    data['linkurl'] = this.linkurl;
    data['linktype'] = this.linktype;
    return data;
  }
}