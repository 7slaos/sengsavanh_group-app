class AdminDashboardModel {
  String? totalincomeAll;
  String? totalincomeAllCash;
  String? totalincomeAllTransfer;
  String? totalAll;
  String? totalIncome;
  String? totalDebt;
  String? totalExpense;
  String? totalBalance;
  String? studentAll;
  String? studentWomen;
  String? studentMan;
  String? registercountman;
  String? registercountwomen;
  List<Packages>? packages;

  AdminDashboardModel(
      {this.totalincomeAll,
      this.totalincomeAllCash,
      this.totalincomeAllTransfer,
      this.totalAll,
      this.totalIncome,
      this.totalDebt,
      this.totalExpense,
      this.totalBalance,
      this.studentAll,
      this.studentWomen,
      this.studentMan,
      this.packages});

  AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    totalincomeAll = json['total_income_all'].toString();
    totalincomeAllCash = json['total_income_all_cash'].toString();
    totalincomeAllTransfer = json['total_income_all_transfer'].toString();
    totalAll = json['total_all'].toString();
    totalIncome = json['total_income'].toString();
    totalDebt = json['total_debt'].toString();
    totalExpense = json['total_expense'].toString();
    totalBalance = json['total_balance'].toString();
    studentAll = json['student_all'].toString();
    studentWomen = json['student_women'].toString();
    studentMan = json['student_man'].toString();
    registercountman = json['register_count_man'].toString();
    registercountwomen = json['register_count_women'].toString();
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_income_all'] = this.totalincomeAll;
    data['total_income_all_cash'] = this.totalincomeAllCash;
    data['total_income_all_transfer'] = this.totalincomeAllTransfer;
    data['total_all'] = this.totalAll;
    data['total_income'] = this.totalIncome;
    data['total_debt'] = this.totalDebt;
    data['total_expense'] = this.totalExpense;
    data['total_balance'] = this.totalBalance;
    data['student_all'] = this.studentAll;
    data['student_women'] = this.studentWomen;
    data['student_man'] = this.studentMan;
    data['register_count_man'] = this.registercountman;
    data['register_count_women'] = this.registercountwomen;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  String? nameLa;
  String? nameEn;
  String? nameCn;
  String? startDate;
  String? endDate;
  int? expiryCount;

  Packages(
      {this.id,
      this.nameLa,
      this.nameEn,
      this.nameCn,
      this.startDate,
      this.endDate,
      this.expiryCount});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameLa = json['name_la'];
    nameEn = json['name_en'];
    nameCn = json['name_cn'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    expiryCount = json['expiry_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_la'] = this.nameLa;
    data['name_en'] = this.nameEn;
    data['name_cn'] = this.nameCn;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['expiry_count'] = this.expiryCount;
    return data;
  }
}
