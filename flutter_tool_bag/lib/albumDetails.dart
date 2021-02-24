import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/album.dart';
import 'package:flutter_tool_bag/gallery.dart';
import 'appBar.dart';

class AlbumDetails extends StatefulWidget {
  int incomingIndex;

  AlbumDetails(this.incomingIndex);

  @override
  AlbumDetailsState createState() {
    return new AlbumDetailsState();
  }
}

class AlbumDetailsState extends State<AlbumDetails> {
  Album selectedAlbum;
  bool loading;
  List<String> ids;

  @override
  void initState() {
    loading = true;
    ids = [];
    _loadingImageIds();
    super.initState();
    selectedAlbum = Gallery.albums[widget.incomingIndex];
  }

  void _loadingImageIds() async {
    final response = await http.get('https://picsum.photos/v2/list');
    final json = jsonDecode(response.body);
    List<String> _ids = [];
    for (var image in json) {
      _ids.add(image['id']);
    }
    setState(() {
      loading = false;
      ids = _ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: headerNav(context, selectedAlbum.albumName),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImagePage(ids[index]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                'https://picsum.photos/id/${ids[index]}/300/300',
              ),
            ),
          ),
          itemCount: ids.length,
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final String id;

  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          'https://picsum.photos/id/$id/800/800',
        ),
      ),
    );
  }
}
