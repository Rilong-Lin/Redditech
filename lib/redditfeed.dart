import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'main.dart';
import 'auth.dart';
import 'post.dart';
import 'search.dart';

class SimpleAppBarPage extends StatefulWidget {
  static var type = "new";
  const SimpleAppBarPage({Key? key, String? type}) : super(key: key);

  @override
  _SimpleAppBarPageState createState() => _SimpleAppBarPageState();
}

Widget homeRender(BuildContext context, Widget newPost, Widget risingPost,
    Widget hotPost, String title, String subscribers) {
  return DefaultTabController(
    length: 3,
    child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NavDrawer()));
            },
          ),
          actions: [
            subscribers != ""
                ? Text("Suscribers: " + subscribers)
                : const Text(""),
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Search()));
                })
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
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Accueil'),
              Tab(icon: Icon(Icons.article_outlined), text: 'Actualités'),
              Tab(icon: Icon(Icons.star), text: 'Populaire'),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: TabBarView(children: [newPost, risingPost, hotPost])),
  );
}

Widget loading() {
  return SpinKitRipple(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.purple : Colors.green,
        ),
      );
    },
  );
}

class _SimpleAppBarPageState extends State<SimpleAppBarPage> {
  String type = SimpleAppBarPage.type;

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

  @override
  Widget build(BuildContext context) {
    return homeRender(context, newPost, risingPost, hotPost, "Redditech", "");
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getData(String type, var count, List list) async {
    List<Post> listPost = [];
    String subreddit = "";
    Map<String, dynamic> data;

    http.Response response = await http
        .get(Uri.parse("https://oauth.reddit.com/subreddits/mine"), headers: {
      "Authorization": "bearer " + await DataStorage.getData("access_token"),
    });
    data = jsonDecode(response.body);
    for (var i in data["data"]["children"]) {
      subreddit += i['data']['url'].split('/')[2] + '+';
    }
    response = await http.get(
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
}

class EndRender {
  static Scaffold renderProfile(listPost, _postController, _scrollController) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: listPost.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int i) {
              return postRender(listPost[i]);
            }),
      )
    ]));
  }
}
