class PackageModel {
  int? id;
  String? name;
  String? price;
  String? userCount;
  String? interval;
  String? intervalCount;
  String? branchCount;
  List<Items>? items;

  PackageModel(
      {this.id,
      this.name,
      this.price,
      this.userCount,
      this.interval,
      this.intervalCount,
      this.branchCount,
      this.items});

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toString();
    userCount = json['user_count'].toString();
    interval = json['interval'];
    intervalCount = json['interval_count'].toString();
    branchCount = json['branch_count'].toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['user_count'] = this.userCount;
    data['interval'] = this.interval;
    data['interval_count'] = this.intervalCount;
    data['branch_count'] = this.branchCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? price;
  String? des;
  List<Childs>? childs;

  Items({this.id, this.name, this.price, this.des, this.childs});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    des = json['des'];
    if (json['childs'] != null) {
      childs = <Childs>[];
      json['childs'].forEach((v) {
        childs!.add(new Childs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['des'] = this.des;
    if (this.childs != null) {
      data['childs'] = this.childs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Childs {
  int? id;
  int? parentId;
  String? name;
  String? price;
  String? des;

  Childs({this.id, this.parentId, this.name, this.price, this.des});

  Childs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    price = json['price'];
    des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['des'] = this.des;
    return data;
  }
}
