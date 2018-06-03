import 'package:anithing/data/anime.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatelessWidget{

  final Anime anime;

  DetailPage({Key key, this.anime}) : super(key : key);

  List<Widget> genreBoxBuilder(){
    List<Widget> genreBox = [];
    for(String genre in anime.genres){
      genreBox.add(
          Chip(
              label: Text(genre, style: TextStyle(fontSize: 11.0, color: Colors.white)),
              backgroundColor: Colors.teal,
          )
      );
    }
    return genreBox;
  }

  @override
  Widget build(BuildContext context) {

    Widget appBar = SliverAppBar(
        title: Text(anime.title),
        expandedHeight: 250.0,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: CachedNetworkImage(imageUrl: anime.coverImage, fit: BoxFit.cover),
        ),
    );

    Widget pictureBox = Container(
      padding: const EdgeInsets.all(10.0),
      width: 200.0,
      child: Hero(
        tag: anime.title,
        child: CachedNetworkImage(
          imageUrl: anime.posterImage,
          fit: BoxFit.fill,
        ),
      ),
    );

    Widget ratingBox = Expanded(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.lightGreen,
                border: Border.all(color: Colors.teal, width: 3.0)
              ),
              child: Text(anime.rating, style: TextStyle(fontSize: 30.0, color: Colors.white)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30.0),
              child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: genreBoxBuilder()
              )
            )
          ]
        ),
    );

    Widget topContent = Row(
      children: <Widget>[
        pictureBox,
        ratingBox
      ],
    );

    Widget bottomContent = Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.blueAccent,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(anime.summary, textAlign: TextAlign.justify, style: TextStyle(color: Colors.white),),
          )
        ],
      )
    );

    Widget body = SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          topContent,
          bottomContent
        ],
      )
    );

    Widget scrollView = CustomScrollView(
      slivers: <Widget>[
        appBar,
        body
      ],
    );

    return Scaffold(
      body: scrollView,
    );
  }
}