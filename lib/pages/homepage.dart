

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skonee_search/pages/searchResultPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Search the world with Skonee"),),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Find anything"),
            controller: searchController,
          ),
          ElevatedButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchResults()));
          }, child: const Text("Search"))
        ],
      )
    );
  }
}