import 'package:flutter/material.dart';
import 'package:news_app/model/model.dart';
import 'package:news_app/apiservice/news_api.dart';
import 'package:news_app/newsscreen/news_screen.dart';
import '../searchfunction/search.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

List<NewsApiModel>? newsList;
List<NewsApiModel>? bookmarkedNews = [];

class _NewsPageState extends State<NewsPage> {
  bool isLoading = true;
  bool isPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          newsList = value;
          isLoading = false;
        } else {
          print("List is Empty");
        }
      });
    });
  }

  _pressed1(int i) {
    var newVal = true;
    // print(newsList![i].color);
    if (newsList![i].color) {
      newsList![i].color = false;
      newVal = false;
    } else {
      newsList![i].color = true;
      newVal = true;
    }
    setState(() {
      // newsList ;
      newsList![i].color = newVal;
    });
  }

  _pressed(int i) {
    var newVal = true;
    // print(bookmarkedNews![i].title);

    for (int j = 0; j < newsList!.length; j++) {
      if (newsList![j].title.contains(bookmarkedNews![i].title)) {
        newsList![j].color = false;
        newVal = false;

        setState(() {
          newsList![j].color = newVal;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leadingWidth: 40,
            bottom: const TabBar(tabs: [
              Tab(
                child: Text(
                  "Top Headlines",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                  child: Text(
                "Bookmarks",
                style: TextStyle(color: Colors.black),
              ))
            ]),
            leading: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            title: Center(
                child: Text(
              "News App",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            )),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    isLoading
                        ? Container(
                            height: size.height / 20,
                            width: size.height / 20,
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: newsList!.length,
                                itemBuilder: (context, index) {
                                  return listItems(
                                      size, newsList![index], index);
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    isLoading
                        ? Container(
                            height: size.height / 20,
                            width: size.height / 20,
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: bookmarkedNews!.length,
                                itemBuilder: (context, index) {
                                  return listbookmarkedItems(
                                      size, bookmarkedNews![index], index);
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listItems(Size size, NewsApiModel model, int index) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReadingNews(
                model: model,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            width: size.width / 1.15,
            // decoration: BoxDecoration(
            //   border: Border.all(width: 1, color: Colors.black),
            // ),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Container(
                    height: size.height / 4,
                    width: size.width / 1.05,
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //     bottom: BorderSide(width: 1, color: Colors.black),
                    //   ),
                    // ),
                    child: model.imageUrl != ""
                        ? Image.network(
                            model.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Text("Cant Load image"),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Date :",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            split(model.date),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _pressed1(index);
                                if (model.color == true) {
                                  bookmarkedNews!.add(model);
                                } else {
                                  bookmarkedNews!.remove(model);
                                }
                              });
                            },
                            icon: Icon(Icons.bookmark,
                                color: (model.color == true)
                                    ? Colors.amber
                                    : Colors.grey),
                            // icon: Icon(isPressed? Icons.bookmark_outline : Icons.bookmark),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listbookmarkedItems(Size size, NewsApiModel model, int index) {
    return Card(
      shadowColor: Colors.grey,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReadingNews(
                model: model,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            width: size.width / 1.15,
            // decoration: BoxDecoration(
            //   border: Border.all(width: 1, color: Colors.black),
            // ),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Container(
                    height: size.height / 4,
                    width: size.width / 1.05,
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //     bottom: BorderSide(width: 1, color: Colors.black),
                    //   ),
                    // ),
                    child: model.imageUrl != ""
                        ? Image.network(
                            model.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Text("Cant Load image"),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Date :",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            split(model.date),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _pressed(index);
                                  bookmarkedNews!.remove(model);
                                  print(index);
                                  print(model.title);
                                  print(newsList![index].title);
                                  print(newsList![index].color);
                                });
                              },
                              icon: Icon(
                                Icons.delete_forever,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String split(String date) {
    String api = date;
    var main;
    int idx = api.indexOf("T");
    List parts = [api.substring(0, idx).trim(), api.substring(idx + 1).trim()];
    main = parts[0].toString();
    // debugPrint('https://opms.quadworld.in/image/'+parts[1].toString());
    return main;
  }
}
