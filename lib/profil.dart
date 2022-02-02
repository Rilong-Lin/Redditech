import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'auth.dart';

class GetProfil extends StatefulWidget {
  const GetProfil({Key? key}) : super(key: key);

  @override
  ProfileApp createState() => ProfileApp();
}

class ProfileApp extends State<GetProfil> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              !snapshot.hasError) {
            Map values = snapshot.data!;
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.blue])),
                      child: SizedBox(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  values["icon_img"].toString(),
                                ),
                                radius: 50.0,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                values["name"],
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 22.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "${values['subscribers'] ?? '0'} subscribers",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Karma " +
                                                  values['total_karma']
                                                      .toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Bio:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontStyle: FontStyle.normal,
                              fontSize: 28.0),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          values['subreddit']['public_description'] ?? "",
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.blue])),
                      child: SizedBox(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const CircleAvatar(
                                // backgroundImage: NetworkImage (
                                //     "",
                                // ),
                                radius: 50.0,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Text(
                                "User",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 22.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: const <Widget>[
                                            Text(
                                              "0 ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "subscribers",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: const <Widget>[
                                            Text(
                                              "Karma ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          "Bio: ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontStyle: FontStyle.normal,
                              fontSize: 28.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Future<Map<String, dynamic>> getData() async {
    http.Response response = await http.get(
        Uri.parse("https://oauth.reddit.com/api/v1/me/?raw_json=1"),
        headers: {
          "Authorization":
              "bearer " + await DataStorage.getData("access_token"),
        });
    return json.decode(response.body);
  }
}
