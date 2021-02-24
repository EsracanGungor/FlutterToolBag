import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/albumDetails.dart';
import 'package:flutter_tool_bag/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'album.dart';
import 'appBar.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
        debugShowCheckedModeBanner: false,
        routes: {
          "/gallery": (context) => Gallery(),
        },
        onGenerateRoute: (RouteSettings settings) {
          List<String> pathElements = settings.name.split("/");
          if (pathElements[1] == 'albumDetails') {
            return MaterialPageRoute(
              builder: (context) => AlbumDetails(int.parse(pathElements[2])),
            );
          }
          return null;
        },
        home: Scaffold(
          backgroundColor:Theme.of(context).backgroundColor,
          appBar: headerNav(context,'Albums'),
          body: Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/albumDetails/$index");
                },
                child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: albumCard(context, index)),
              ),
              itemCount: albums.length,
            ),
          ),
        ));
  }

  static List<Album> albums = <Album>[
    Album(
        albumName: "Family",
        albumDetails: "805 photos, 60 videos",
        albumImage: "images/family.png"),
    Album(
        albumName: "Camera",
        albumDetails: "47  photos,  3 videos",
        albumImage: "images/camera2.png"),
    Album(
        albumName: "Favorites",
        albumDetails: "4   photos,  1 videos",
        albumImage: "images/favorites3.png"),
    Album(
        albumName: "Screenshots",
        albumDetails: "48   photos",
        albumImage: "images/screenshots4.png"),
    Album(
        albumName: "WhatsApp",
        albumDetails: "143 photos, 15 videos",
        albumImage: "images/whatsapp5.png"),
    Album(
        albumName: "Download",
        albumDetails: "598 photos,  8 videos",
        albumImage: "images/download6.png"),
    Album(
        albumName: "Wallpapers",
        albumDetails: "143 photos,  3 videos",
        albumImage: "images/wallpapers7.png"),
  ];

  Widget albumCard(BuildContext context, int index) {
    Album currentAlbum = albums[index];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color:Theme.of(context).accentColor,
            spreadRadius: 6,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              currentAlbum.albumImage,
              height: 120,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentAlbum.albumName,
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  currentAlbum.albumDetails,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
