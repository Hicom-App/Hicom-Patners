class SortedPayTransactions {
  int? status;
  String? message;
  List<Result>? result;

  SortedPayTransactions({this.status, this.message, this.result});

  SortedPayTransactions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
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
  // Helper function to group and sort by date
  List<Result> _groupResultsByDate(List<Results> results) {
    Map<String, List<Results>> groupedData = {};
    for (var result in results) {
      // DateTime.parse bilan UTC vaqtini o'zgartirmay olish
      final date = DateTime.parse(result.dateCreated!);
      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (!groupedData.containsKey(formattedDate)) {
        groupedData[formattedDate] = [];
      }
      groupedData[formattedDate]!.add(result);
    }
    // Guruhlangan natijalarni sanaga qarab sortlash
    var sortedEntries = groupedData.entries.toList()..sort((a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)));
    return sortedEntries.map((entry) {
      entry.value.sort((a, b) => DateTime.parse(b.dateCreated!).compareTo(DateTime.parse(a.dateCreated!)));
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
  String? firstName;
  String? lastName;
  int? amount;
  int? cardId;
  int? codeId;
  String? cardNo;
  String? cardHolder;
  String? dateEdited;
  String? description;

  Results({this.id, this.operation, this.dateCreated, this.userId, this.firstName, this.lastName, this.amount, this.cardId, this.codeId, this.cardNo, this.cardHolder, this.dateEdited, this.description});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operation = json['operation'];
    dateCreated = json['date_created'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    amount = json['amount'];
    cardId = json['card_id'];
    codeId = json['code_id'];
    cardNo = json['card_no'];
    cardHolder = json['card_holder'];
    dateEdited = json['date_edited'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operation'] = operation;
    data['date_created'] = dateCreated;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['amount'] = amount;
    data['card_id'] = cardId;
    data['code_id'] = codeId;
    data['card_no'] = cardNo;
    data['card_holder'] = cardHolder;
    data['date_edited'] = dateEdited;
    data['description'] = description;
    return data;
  }
}
