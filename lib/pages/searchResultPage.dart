

import 'package:html/parser.dart' as parser;

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
    searchController = TextEditingController(text: widget.searchTerm);
    currentSearchQuery = widget.searchTerm;
  }
  late TextEditingController searchController;
  String currentSearchQuery = '';


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateSearchResults(String newQuery) {
    setState(() {
      currentSearchQuery = newQuery;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: updateSearchResults,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              updateSearchResults(searchController.text);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<Result>>(
        future: SearchService().getResults(currentSearchQuery),
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

    return descriptionToolTip(
      description: result.description,
      child: ListTile(
        onTap: (){
          _launchUrl(url);
        },
        title: Text(result.title.toString()),
        subtitle: Text(result.url.toString()),
        leading: Image.network(result.image,
          errorBuilder: (context, error, stackTrace) => Image(image: AssetImage('Assets/webicon.png')),
        ),
      ),
    );
  }
  Widget descriptionToolTip({String? description, required Widget child}) {
    return Tooltip(
      message: parser.parseFragment(description).text,
      triggerMode: TooltipTriggerMode.longPress,
      showDuration: const Duration(seconds: 30),
      child: child,

    );
  }



  _getImage(String imageUrl) {
      // return Image.network(imageUrl, errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
      //   return Text('Your error widget...');
      // },);
  }
  _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      Stream.error("error");
    }
  }
}

