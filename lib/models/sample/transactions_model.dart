class TransactionsModel {
  int? status;
  String? message;
  List<Result>? result;

  TransactionsModel({this.status, this.message, this.result});

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  int? operation;
  String? dateCreated;
  int? userId;
  int? amount;
  int? cardId;
  int? codeId;
  String? dateEdited;
  String? description;

  Result({this.id, this.operation, this.dateCreated, this.userId, this.amount, this.cardId, this.codeId, this.dateEdited, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operation = json['operation'];
    dateCreated = json['date_created'];
    userId = json['user_id'];
    amount = json['amount'];
    cardId = json['card_id'];
    codeId = json['code_id'];
    dateEdited = json['date_edited'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operation'] = operation;
    data['date_created'] = dateCreated;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['card_id'] = cardId;
    data['code_id'] = codeId;
    data['date_edited'] = dateEdited;
    data['description'] = description;
    return data;
  }
}
