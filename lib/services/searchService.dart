import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skonee_search/models/resultModel.dart';

class SearchService {
  static const _apiKey = 'BSAPBPOqLh9PEaHIlLH4proulQzM2pC';
  final httpClient = http.Client();

  Future<List<Result>> getResults(final searchTerm) async {
    final requestUrl =
        'https://api.search.brave.com/res/v1/web/search?q=$searchTerm';
    final response = await httpClient
        .get(Uri.parse(requestUrl), headers: {"X-Subscription-Token": _apiKey});

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
