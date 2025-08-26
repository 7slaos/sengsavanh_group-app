class PaymentPackageLogModel {
  int? id;
  String? userPay;
  int? monthQty;
  String? type;
  int? studentCount;
  String? price;
  String? total;
  String? paymentType;
  String? refPayment;
  int? status;
  int? approveId;
  String? note;
  String? createdAt;

  PaymentPackageLogModel(
      {this.id,
      this.userPay,
      this.monthQty,
      this.type,
      this.studentCount,
      this.price,
      this.total,
      this.paymentType,
      this.refPayment,
      this.status,
      this.approveId,
      this.note,
      this.createdAt});

  PaymentPackageLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userPay = json['user_pay'];
    monthQty = json['month_qty'];
    type = json['type'];
    studentCount = json['student_count'];
    price = json['price'];
    total = json['total'];
    paymentType = json['payment_type'];
    refPayment = json['ref_payment'];
    status = json['status'];
    approveId = json['approve_id'];
    note = json['note'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_pay'] = this.userPay;
    data['month_qty'] = this.monthQty;
    data['type'] = this.type;
    data['student_count'] = this.studentCount;
    data['price'] = this.price;
    data['total'] = this.total;
    data['payment_type'] = this.paymentType;
    data['ref_payment'] = this.refPayment;
    data['status'] = this.status;
    data['approve_id'] = this.approveId;
    data['note'] = this.note;
    data['created_at'] = this.createdAt;
    return data;
  }
}