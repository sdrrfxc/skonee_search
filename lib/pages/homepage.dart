import 'package:flutter/material.dart';
import 'package:skonee_search/pages/searchResultPage.dart';

class HomePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + 20.0), // Add 20.0 padding
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 20.0), // Add 20.0 padding
            child: Text(
              "",
              style: TextStyle(
                  // Set font color to blue
                  ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Search with Skonee",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(
                    255, 11, 101, 175), // Set font color to blue
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: "Search to your heart's content",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              ),
              controller: searchController,
              onSubmitted: (query) {
                // Navigate to search results page when the user submits the search query
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchResults(searchQuery: query),
                ));
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to search results page when the user clicks the button
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      SearchResults(searchQuery: searchController.text),
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              ),
              child: Text(
                "Search",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
