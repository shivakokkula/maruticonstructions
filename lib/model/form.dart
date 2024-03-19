class Work {
  String amount;
  String name;
  String reason;
  String month;
  String mobile;
  String date;
  String sheet;

  Work(this.amount, this.name, this.reason,this.month,this.mobile,
      this.date,this.sheet);

  factory Work.fromJson(dynamic json) {
    return Work("${json['amount']}","${json['name']}","${json['reason']}",
        "${json['month']}","${json['mobile']}","${json['date']}","${json['sheet']}");
  }

  Map toJson() => {
    'amount': amount,
    'name': name,
    'reason': reason,
    'mobile': mobile,
    'month': month,
    'date':date,
    'sheet':sheet
  };
}