class AdminExpenseModel {
  String? total;
  List<Items>? items;

  AdminExpenseModel({this.total, this.items});

  AdminExpenseModel.fromJson(Map<String, dynamic> json) {
    total = json['total'].toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['total'] = this.total;
  //   if (this.items != null) {
  //     data['items'] = this.items!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Items {
  int? id;
  String? category;
  String? firstname;
  String? lastname;
  String? image;
  int? payType;
  String? name;
  String? subtotal;
  String? dated;

  Items(
      {this.id,
      this.category,
      this.firstname,
      this.lastname,
      this.image,
      this.payType,
      this.name,
      this.subtotal,
      this.dated});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    image = json['image'];
    payType = json['pay_type'];
    name = json['name'];
    subtotal = json['subtotal'];
    dated = json['dated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['image'] = this.image;
    data['pay_type'] = this.payType;
    data['name'] = this.name;
    data['subtotal'] = this.subtotal;
    data['dated'] = this.dated;
    return data;
  }
}
