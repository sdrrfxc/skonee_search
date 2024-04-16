import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skonee_search/models/resultModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/searchService.dart';

class SearchResults extends StatefulWidget {
  final String searchTerm;
  const SearchResults({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Result>>(
        future: SearchService().getResults(widget.searchTerm),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data!;
            return _search(results);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // Display a loading indicator while fetching results
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _search(List<Result> results) {
    return ListView.separated(
      itemBuilder: (_, index) => _toWidget(results[index]),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: results.length,
    );
  }

  Widget _toWidget(Result result) {
    final Uri url = Uri.parse(result.url.toString());
    return ListTile(
      onTap: (){
        _launchUrl(url);
      },
      title: Text(result.title.toString()),
      subtitle: Text(result.url.toString()),
    );
  }
  _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      Stream.error("error");
    }
  }
}