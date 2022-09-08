class NewsApiModel {
  String title, imageUrl, content, description, author, date;
  bool color;

  NewsApiModel(
      {required this.title,
      required this.description,
      required this.content,
      required this.imageUrl,
      required this.author,
      required this.date,
      required this.color});

  factory NewsApiModel.fromJson(Map<String, dynamic> jsonData) {
    return NewsApiModel(
        title: jsonData['title'] ?? "",
        description: jsonData['description'] ?? "",
        content: jsonData['content'] ?? "",
        imageUrl: jsonData['image'] ?? "",
        author: jsonData['source']['name'] ?? "",
        date: jsonData['publishedAt'] ?? "",
        color: false);
  }
}
