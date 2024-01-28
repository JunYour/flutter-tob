class HomeMenu {
  String imgurl;
  String linkurl;
  String text;
  String color;
  String type;

  HomeMenu({this.imgurl, this.linkurl, this.text, this.color, this.type});

  HomeMenu.fromJson(Map<String, dynamic> json) {
    imgurl = json['imgurl'];
    linkurl = json['linkurl'];
    text = json['text'];
    color = json['color'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgurl'] = this.imgurl;
    data['linkurl'] = this.linkurl;
    data['text'] = this.text;
    data['color'] = this.color;
    data['type'] = this.type;
    return data;
  }
}