class HomeBanner {
  String imgurl;
  String linkurl;
  String type;

  HomeBanner({this.imgurl, this.linkurl, this.type});

  HomeBanner.fromJson(Map<String, dynamic> json) {
    imgurl = json['imgurl'];
    linkurl = json['linkurl'];
    type = json['linktype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgurl'] = this.imgurl;
    data['linkurl'] = this.linkurl;
    data['linktype'] = this.type;
    return data;
  }
}