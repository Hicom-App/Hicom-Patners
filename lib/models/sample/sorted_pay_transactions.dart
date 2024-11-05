class SortedPayTransactions {
  int? status;
  String? message;
  List<Result>? result;

  SortedPayTransactions({this.status, this.message, this.result});

  SortedPayTransactions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['result'] != null) {
      // Parse and group results by date
      var results = <Results>[];
      json['result'].forEach((v) {
        results.add(Results.fromJson(v));
      });
      result = _groupResultsByDate(results);
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

  // Helper function to group by date
  List<Result> _groupResultsByDate(List<Results> results) {
    Map<String, List<Results>> groupedData = {};

    for (var result in results) {
      final date = DateTime.parse(result.dateCreated!).toLocal();
      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedData.containsKey(formattedDate)) {
        groupedData[formattedDate] = [];
      }
      groupedData[formattedDate]!.add(result);
    }

    return groupedData.entries.map((entry) {
      return Result(date: entry.key, results: entry.value);
    }).toList();
  }
}

class Result {
  String? date;
  List<Results>? results;

  Result({this.date, this.results});

  Result.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  int? operation;
  String? dateCreated;
  int? userId;
  int? amount;
  int? cardId;
  int? codeId;
  String? dateEdited;
  String? description;

  Results({this.id, this.operation, this.dateCreated, this.userId, this.amount, this.cardId, this.codeId, this.dateEdited, this.description});

  Results.fromJson(Map<String, dynamic> json) {
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