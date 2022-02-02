import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
import 'package:mime/mime.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class Post {
  final String? sub;
  final String? title;
  final String? text;
  final int upVote;
  final int downVote;
  final String? thumbnail;
  final String? urlOverridden;
  final String? id;

  Post({
    required this.sub,
    required this.title,
    required this.text,
    required this.upVote,
    required this.downVote,
    required this.thumbnail,
    required this.urlOverridden,
    required this.id,
  });

  factory Post.fromJson(dynamic post) {
    return Post(
        sub: post['data']['subreddit_name_prefixed'],
        title: post['data']['title'],
        text: post['data']['selftext'],
        upVote: post['data']['ups'],
        downVote: post['data']['downs'],
        thumbnail: post['data']['thumbail'],
        urlOverridden: post['data']['url_overridden_by_dest'],
        id: post['data']['name']);
  }
}

void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}

Widget media(String? str) {
  var type = lookupMimeType(str.toString());
  var ext = type.toString().split('/');

  if (ext[0] == "image") {
    return CachedNetworkImage(imageUrl: str.toString(), fit: BoxFit.cover);
  }
  if (str != null && !str.contains("redd.it") && !str.contains("reddit")) {
    return ElevatedButton(
        onPressed: () => launchURL(str),
        child: FlutterLinkPreview(url: str.toString()));
  }
  return const Text("");
}

Widget postRender(Post post) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(post.sub.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            Text(post.title.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text(post.text.toString(), style: const TextStyle(fontSize: 14)),
            media(post.urlOverridden),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const LikeButton(),
              LikeButton(
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Color(0xad25cc),
                  dotSecondaryColor: Color(0x5f0973),
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.thumb_down,
                    color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                    size: 30,
                  );
                },
              ),
            ])
          ]));
}
