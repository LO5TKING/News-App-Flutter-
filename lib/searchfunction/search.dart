import 'package:flutter/material.dart';
import 'package:news_app/homepage/newspage.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    var f = newsList;
    if (f != null) {
      for (var headline in f) {
        if (headline.title.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(headline.title);
        } else {
          // print(headline.title.toLowerCase());
        }
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    var f = newsList;
    if (f != null) {
      for (var headline in f) {
        if (headline.title.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(headline.title);
        }
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }
}
