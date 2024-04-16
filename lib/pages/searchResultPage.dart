import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  final String searchQuery;

  const SearchResults({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late TextEditingController searchController;
  String currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchQuery);
    currentSearchQuery = widget.searchQuery;
  }

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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Search Results for '$currentSearchQuery'"),
            onTap: () {},
          );
        },
      ),
    );
  }
}
