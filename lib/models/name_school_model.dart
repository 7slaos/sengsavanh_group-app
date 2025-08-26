class AuthNameSchoolModel {
  int? id;
  String? logo;
  String? qrCode;
  String? nameLa;
  String? nameEn;
  String? nameCn;
  String? phone;
  String? email;
  int? villId;
  int? disId;
  int? proId;
  String? addressLa;
  String? addressCn;
  String? addressEn;
  String? directorSign;
  String? chechkerSign;
  String? customerSign;
  String? staffSign;
  int? status;
  int? discount;
  String? expireDiscountDay;
  String? villageName;
  String? distractName;
  String? provinceName;

  AuthNameSchoolModel(
      {this.id,
      this.logo,
      this.qrCode,
      this.nameLa,
      this.nameEn,
      this.nameCn,
      this.phone,
      this.email,
      this.villId,
      this.disId,
      this.proId,
      this.addressLa,
      this.addressCn,
      this.addressEn,
      this.directorSign,
      this.chechkerSign,
      this.customerSign,
      this.staffSign,
      this.status,
      this.discount,
      this.expireDiscountDay,
      this.villageName,
      this.distractName,
      this.provinceName});

  AuthNameSchoolModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    qrCode = json['qr_code'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    nameCn = json['name_cn'];
    phone = json['phone'];
    email = json['email'];
    villId = json['vill_id'];
    disId = json['dis_id'];
    proId = json['pro_id'];
    addressLa = json['address_la'];
    addressCn = json['address_cn'];
    addressEn = json['address_en'];
    directorSign = json['director_sign'];
    chechkerSign = json['chechker_sign'];
    customerSign = json['customer_sign'];
    staffSign = json['staff_sign'];
    status = json['status'];
    discount = json['discount'];
    expireDiscountDay = json['expire_discount_day'];
    villageName = json['village_name'];
    distractName = json['distract_name'];
    provinceName = json['province_name'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['logo'] = this.logo;
  //   data['qr_code'] = this.qrCode;
  //   data['name_la'] = this.nameLa;
  //   data['name_en'] = this.nameEn;
  //   data['name_cn'] = this.nameCn;
  //   data['phone'] = this.phone;
  //   data['email'] = this.email;
  //   data['vill_id'] = this.villId;
  //   data['dis_id'] = this.disId;
  //   data['pro_id'] = this.proId;
  //   data['address_la'] = this.addressLa;
  //   data['address_cn'] = this.addressCn;
  //   data['address_en'] = this.addressEn;
  //   data['director_sign'] = this.directorSign;
  //   data['chechker_sign'] = this.chechkerSign;
  //   data['customer_sign'] = this.customerSign;
  //   data['staff_sign'] = this.staffSign;
  //   data['status'] = this.status;
  //   data['discount'] = this.discount;
  //   data['expire_discount_day'] = this.expireDiscountDay;
  //   data['village_name'] = this.villageName;
  //   data['distract_name'] = this.distractName;
  //   data['province_name'] = this.provinceName;
  //   return data;
  // }
}