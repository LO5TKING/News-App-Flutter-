import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/model.dart';

Future<List<NewsApiModel>> getNews() async {
  Uri uri = Uri.parse(
      "https://gnews.io/api/v4/search?q=in&token=211e013f344b7350dcae15d4de5ad53c");

  final response = await http.get(uri);

  if (response.statusCode == 200 || response.statusCode == 201) {
    Map<String, dynamic> map = json.decode(response.body);

    List _articalsList = map['articles'];

    List<NewsApiModel> newsList = _articalsList
        .map((jsonData) => NewsApiModel.fromJson(jsonData))
        .toList();

    return newsList;
  } else {
    print("error");
    return [];
  }
}