import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:skonee_search/models/resultModel.dart';
import 'package:skonee_search/auth/secrets.dart';


class SearchService {
  final httpClient = http.Client();

  Future<List<Result>> getResults(final searchTerm) async {
    final apiKey =  secretKey;
    final requestUrl =
        'https://api.search.brave.com/res/v1/web/search?q=$searchTerm';
    final response = await httpClient
        .get(Uri.parse(requestUrl), headers: {"X-Subscription-Token": apiKey});

    List<Result> returnResultList = [];
    final json = jsonDecode(response.body);
    final web = json['web'];
    final results = web['results'];
    results.toList().forEach((result) => {
      returnResultList.add(Result.parse(result))
    });
    print(returnResultList);
    return returnResultList;
  }


}
