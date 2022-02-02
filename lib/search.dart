import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'auth.dart';
import 'redditfeed.dart';
import 'post.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchPage createState() => SearchPage();
}

class SearchPage extends State<Search> {
  List result = [];
  List subData = [];
  Widget tmp = const Text("");
  var search = "";
  final textController = TextEditingController();

  getSearchResult(String input) async {
    http.post(Uri.parse("https://oauth.reddit.com/api/search_subreddits"),
        headers: {
          'Authorization':
              'bearer ' + await DataStorage.getData("access_token"),
        },
        body: {
          "query": input,
          "exact": "false"
        }).then((http.Response rep) {
      String body = rep.body;
      Map<String, dynamic> info = jsonDecode(body);
      setState(() {
        result = info['subreddits'];
      });
    });
  }

  Future<Subreddit> getSubredditInfo(String input) async {
    Map<String, dynamic> data;

    print(input);
    http.Response res = await http
        .get(Uri.parse("https://oauth.reddit.com/r/$input/about"), headers: {
      'Authorization': 'bearer ' + await DataStorage.getData("access_token"),
    });
    data = jsonDecode(res.body.toString());
    return Subreddit.fromJson(data);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Enter a subreddit\'s name');

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    trailing: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          await getSearchResult(textController.text);
                          tmp = resultRender();
                        }),
                    title: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a subreddit\'s name',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Enter a subreddit\'s name');
                }
              });
            },
            icon: customIcon,
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: tmp,
      backgroundColor: Colors.grey[200]);

  resultRender() {
    return (ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: result.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                if (result[index]["name"] != "") {
                  Subreddit sub = await getSubredditInfo(result[index]["name"]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowSubreddit(subreddit: sub)));
                }
              },
              child: Container(
                height: 50,
                color: Colors.grey,
                child: Center(
                    child: Text(
                  result[index]['name'],
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1),
                )),
              ));
        }));
  }
}

class Subreddit {
  final String? name;
  final int subscribers;
  final String? desc;
  final String? banner;
  final String? icon;

  Subreddit({
    required this.name,
    required this.subscribers,
    required this.desc,
    required this.banner,
    required this.icon,
  });

  factory Subreddit.fromJson(dynamic sub) {
    return Subreddit(
      name: sub['data']['display_name'],
      subscribers: sub['data']['subscribers'],
      desc: sub['data']['public_description'],
      banner: sub['data']['banner_background_image'],
      icon: sub['data']['icon_img'],
    );
  }
}

class ShowSubreddit extends StatefulWidget {
  const ShowSubreddit({Key? key, required this.subreddit}) : super(key: key);
  final Subreddit subreddit;

  @override
  CreateSubreddit createState() => CreateSubreddit();
}

class CreateSubreddit extends State<ShowSubreddit> {
  var newId = "";
  var risingId = "";
  var hotId = "";
  var listNew = [];
  var listRising = [];
  var listHot = [];
  Widget newPost = loading();
  Widget risingPost = loading();
  Widget hotPost = loading();

  final PagingController<int, Widget> _postController =
      PagingController(firstPageKey: 0);
  final ScrollController _scrollController = ScrollController();

  IconButton closeTreadShow(context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName("/home"));
      },
    );
  }

  void getData(String type, var count, List list) async {
    List<Post> listPost = [];
    String subreddit = widget.subreddit.name.toString();
    Map<String, dynamic> data;

    http.Response response = await http.get(
        Uri.parse(
            "https://oauth.reddit.com/r/$subreddit/$type.json?after=$count"),
        headers: {
          "Authorization":
              "bearer " + await DataStorage.getData("access_token"),
        });
    data = jsonDecode(response.body);
    for (var i in data["data"]["children"]) {
      listPost.add(Post.fromJson(i));
    }
    if (type == "new") {
      setState(() {
        listNew += listPost;
        newPost = EndRender.renderProfile(
            listNew, _postController, _scrollController);
        newId = listPost.last.id.toString();
      });
    } else if (type == "rising") {
      setState(() {
        listRising += listPost;
        risingPost = EndRender.renderProfile(
            listRising, _postController, _scrollController);
        risingId = listPost.last.id.toString();
      });
    } else {
      setState(() {
        listHot += listPost;
        hotPost = EndRender.renderProfile(
            listHot, _postController, _scrollController);
        hotId = listPost.last.id.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        getData("new", newId, listNew);
        getData("rising", risingId, listRising);
        getData("hot", hotId, listHot);
      }
    });
    getData("new", newId, listNew);
    getData("rising", risingId, listRising);
    getData("hot", hotId, listHot);
  }

  tes() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsetsDirectional.only(top: 50, bottom: 10),
              width: double.infinity,
              child: const Padding(padding: EdgeInsets.all(3))),
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 10),
              child: Text("Followers: ${widget.subreddit.subscribers}",
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Container(
              padding: const EdgeInsetsDirectional.only(bottom: 10),
              child: Text("Followers: ${widget.subreddit.subscribers}",
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return homeRender(
        context,
        newPost,
        risingPost,
        hotPost,
        widget.subreddit.name.toString(),
        widget.subreddit.subscribers.toString());
  }
}
