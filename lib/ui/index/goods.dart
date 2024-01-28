class HomeGoods {
  int id;
  int carId;
  int brandId;
  int seriesId;
  String carName;
  String seriesName;
  String brandName;
  String primePrice;
  String normalPrice;
  int total;
  int buycount;
  String images;
  int pubTime;
  String expire;
  String carcity;
  String salecity;
  List<String> detailLabels;
  List<String> listLabels;
  int status;
  int deliveryStatus;
  String remark;
  Cars cars;
  String indexImage;
  String salecityName;
  String carcityName;

  HomeGoods(
      {this.id,
      this.carId,
      this.brandId,
      this.seriesId,
      this.carName,
      this.seriesName,
      this.brandName,
      this.primePrice,
      this.normalPrice,
      this.total,
      this.buycount,
      this.images,
      this.pubTime,
      this.expire,
      this.carcity,
      this.salecity,
      this.detailLabels,
      this.listLabels,
      this.status,
      this.deliveryStatus,
      this.remark,
      this.cars,
      this.indexImage,
      this.salecityName,
      this.carcityName});

  HomeGoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carId = json['carId'];
    brandId = json['brandId'];
    seriesId = json['seriesId'];
    carName = json['carName'];
    seriesName = json['seriesName'];
    brandName = json['brandName'];
    primePrice = json['primePrice'];
    normalPrice = json['normalPrice'];
    total = json['total'];
    buycount = json['buycount'];
    images = json['images'];
    pubTime = json['pubTime'];
    expire = json['expire'];
    carcity = json['carcity'];
    salecity = json['salecity'];
    detailLabels = json['detailLabels'].cast<String>();
    listLabels = json['listLabels'].cast<String>();
    status = json['status'];
    deliveryStatus = json['deliveryStatus'];
    remark = json['remark'];
    cars = json['cars'] != null ? new Cars.fromJson(json['cars']) : null;
    indexImage = json['indexImage'];
    salecityName = json['salecityName'];
    carcityName = json['carcityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['carId'] = this.carId;
    data['brandId'] = this.brandId;
    data['seriesId'] = this.seriesId;
    data['carName'] = this.carName;
    data['seriesName'] = this.seriesName;
    data['brandName'] = this.brandName;
    data['primePrice'] = this.primePrice;
    data['normalPrice'] = this.normalPrice;
    data['total'] = this.total;
    data['buycount'] = this.buycount;
    data['images'] = this.images;
    data['pubTime'] = this.pubTime;
    data['expire'] = this.expire;
    data['carcity'] = this.carcity;
    data['salecity'] = this.salecity;
    data['detailLabels'] = this.detailLabels;
    data['listLabels'] = this.listLabels;
    data['status'] = this.status;
    data['deliveryStatus'] = this.deliveryStatus;
    data['remark'] = this.remark;
    if (this.cars != null) {
      data['cars'] = this.cars.toJson();
    }
    data['indexImage'] = this.indexImage;
    data['salecityName'] = this.salecityName;
    data['carcityName'] = this.carcityName;
    return data;
  }
}

class Cars {
  String pPinpai;
  String pChexi;
  String pChexingmingcheng;
  String pChangshangzhidaojia;
  String pChangshangzhidaojiaYuan;

  Cars(
      {this.pPinpai,
      this.pChexi,
      this.pChexingmingcheng,
      this.pChangshangzhidaojia,
      this.pChangshangzhidaojiaYuan});

  Cars.fromJson(Map<String, dynamic> json) {
    pPinpai = json['p_pinpai'];
    pChexi = json['p_chexi'];
    pChexingmingcheng = json['p_chexingmingcheng'];
    pChangshangzhidaojia = json['p_changshangzhidaojia'];
    pChangshangzhidaojiaYuan = json['p_changshangzhidaojia_yuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_pinpai'] = this.pPinpai;
    data['p_chexi'] = this.pChexi;
    data['p_chexingmingcheng'] = this.pChexingmingcheng;
    data['p_changshangzhidaojia'] = this.pChangshangzhidaojia;
    data['p_changshangzhidaojia_yuan'] = this.pChangshangzhidaojiaYuan;
    return data;
  }
}
