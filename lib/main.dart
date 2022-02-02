import 'auth.dart';
import 'profil.dart';
import 'redditfeed.dart';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const MyStatefulWidget(),
        '/': (BuildContext context) => const GetAuth(),
        '/profil': (BuildContext context) => const GetProfil(),
      },
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 0),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                image:
                    DecorationImage(fit: BoxFit.fill, image: AssetImage(''))),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Mon profil'),
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GetProfil()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Communauté'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_outlined),
            title: const Text('Sauvegarde'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Historique'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètre'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Déconnexion'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MyStatefulWidget> {
  int index = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: buildBottomBar(),
        body: const SimpleAppBarPage(),
        drawer: const NavDrawer(),
      );

  int _selectedIndex = 0;
  Widget buildBottomBar() {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedItemColor: Colors.black,
      selectedIconTheme: const IconThemeData(color: Colors.orange, size: 35),
      selectedItemColor: Colors.orange,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_sharp),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
