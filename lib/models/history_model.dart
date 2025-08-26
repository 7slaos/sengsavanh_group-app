class HistoryModel {
  int? id;
  int? creatorId;
  int? userId;
  String? name;
  int? total;
  String? totalPaid;
  String? discount;
  String? discountPhiset;
  String? issueDate;
  String? dueDate;
  int? status;
  String? note;
  int? giveMoney;
  int? checkAdd;
  String? createdAt;
  String? firstname;
  String? lastname;
  String? myClass;
  String? createFirstName;
  String? createLastName;
  String? billerID;
  String? storeID;
  String? terminalID;
  String? ref2;
  List<PaymentLine>? paymentLine;
  List<DiscountLine>? discountLines;
  String? totalDebt;
  String? transactionIdPayment;
  String? checkfeeInvoice;
  String? bankId;
  String? accessToken;
  String? xClientTransactionDatetime;
  String? partnerId;
  String? digest;
  String? qRcreated;
  String? qRexpires;
  String? signature;
  String? reference2;
  String? logo;
  String? nameLa;
  String? nameEn;
  String? phone;
  HistoryModel(
      {this.id,
      this.creatorId,
      this.userId,
      this.name,
      this.total,
      this.totalPaid,
      this.discount,
      this.discountPhiset,
      this.issueDate,
      this.dueDate,
      this.status,
      this.note,
      this.giveMoney,
      this.checkAdd,
      this.createdAt,
      this.firstname,
      this.lastname,
      this.myClass,
      this.createFirstName,
      this.createLastName,
      this.billerID,
      this.storeID,
      this.terminalID,
      this.paymentLine,
      this.ref2,
      this.discountLines,
      this.totalDebt,
      this.transactionIdPayment,
      this.bankId,this.logo,this.nameLa,this.nameEn, this.phone});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    userId = json['user_id'];
    name = json['name'];
    total = json['total'];
    totalPaid = json['total_paid'];
    discount = json['discount'];
    discountPhiset = json['discount_phiset'];
    issueDate = json['issue_date'];
    dueDate = json['due_date'];
    status = json['status'];
    note = json['note'];
    giveMoney = json['give_money'];
    checkAdd = json['check_add'];
    createdAt = json['created_at'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    myClass = json['my_class'];
    createFirstName = json['create_first_name'];
    createLastName = json['create_last_name'];
    billerID = json['billerID'];
    storeID = json['storeID'];
    terminalID = json['terminalID'];
    ref2 = json['ref2'];
    if (json['payment_line'] != null) {
      paymentLine = <PaymentLine>[];
      json['payment_line'].forEach((v) {
        paymentLine!.add(new PaymentLine.fromJson(v));
      });
    }
    if (json['discount_lines'] != null) {
      discountLines = <DiscountLine>[];
      json['discount_lines'].forEach((v) {
        discountLines!.add(new DiscountLine.fromJson(v));
      });
    }
    totalDebt = json['total_debt'].toString();
    transactionIdPayment = json['transactionId_payment'];
    checkfeeInvoice = json['check_fee_invoice'].toString();
    bankId = json['bank_id'].toString();
    accessToken = json['accessToken'];
    xClientTransactionDatetime = json['xClientTransactionDatetime'];
    partnerId = json['partnerId'];
    digest = json['digest'];
    qRcreated = json['qr_created'];
    qRexpires = json['qr_expires'];
    signature = json['signature'];
    reference2 = json['reference2'];
    logo = json['logo'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creator_id'] = this.creatorId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['total'] = this.total;
    data['total_paid'] = this.totalPaid;
    data['discount'] = this.discount;
    data['discount_phiset'] = this.discountPhiset;
    data['issue_date'] = this.issueDate;
    data['due_date'] = this.dueDate;
    data['status'] = this.status;
    data['note'] = this.note;
    data['give_money'] = this.giveMoney;
    data['check_add'] = this.checkAdd;
    data['created_at'] = this.createdAt;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['my_class'] = this.myClass;
    data['create_first_name'] = this.createFirstName;
    data['create_last_name'] = this.createLastName;
    data['billerID'] = this.billerID;
    data['storeID'] = this.storeID;
    data['terminalID'] = this.terminalID;
    data['ref2'] = this.ref2;
    if (this.paymentLine != null) {
      data['payment_line'] = this.paymentLine!.map((v) => v.toJson()).toList();
    }
    if (this.discountLines != null) {
      data['discount_lines'] =
          this.discountLines!.map((v) => v.toJson()).toList();
    }
    data['total_debt'] = this.totalDebt;
    data['transactionId_payment'] = this.transactionIdPayment;
    data['check_fee_invoice'] = this.checkfeeInvoice;
    data['bank_id'] = this.bankId;
    data['accessToken'] = this.accessToken;
    data['xClientTransactionDatetime'] = this.xClientTransactionDatetime;
    data['partnerId'] = this.partnerId;
    data['digest'] = this.digest;
    data['qr_created'] = this.qRcreated;
    data['qr_expires'] = this.qRexpires;
    data['signature'] = this.signature;
    data['reference2'] = this.reference2;
    data['logo'] = this.logo;
    data['name_la'] = this.nameLa;
    data['name_en'] = this.nameEn;
    data['phone'] = this.phone;
    return data;
  }
}

class PaymentLine {
  int? id;
  String? subtotal;
  int? payType;
  String? billNumber;
  String? billDated;

  PaymentLine(
      {this.id, this.subtotal, this.payType, this.billNumber, this.billDated});

  PaymentLine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subtotal = json['subtotal'].toString();
    payType = json['pay_type'];
    billNumber = json['bill_number'];
    billDated = json['bill_dated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subtotal'] = this.subtotal;
    data['pay_type'] = this.payType;
    data['bill_number'] = this.billNumber;
    data['bill_dated'] = this.billDated;
    return data;
  }
}

class DiscountLine {
  String? name;
  String? discount;

  DiscountLine({
    this.name,
    this.discount,
  });

  DiscountLine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    discount = json['discount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['discount'] = this.discount;
    return data;
  }
}
