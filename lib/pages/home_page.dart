import 'dart:async';
import 'dart:convert';
import 'package:anithing/custom_route.dart';
import 'package:anithing/data/genre.dart';
import 'package:flutter/material.dart';
import 'package:anithing/data/anime.dart';
import 'package:http/http.dart' as http;
import 'package:anithing/helper/url_builder.dart' as urlHelper;
import 'package:anithing/res/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anithing/pages/detail_page.dart';

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  final int _gridNum = 15;
  final List<String> _category = ["popularityRank","ratingRank"];

  int _categoryCode = 0;
  bool _currentlyAiring = false;
  String _searchText = null;
  int _offset = 0;
  Map<String, Anime> _animeList = Map();
  bool _loading = true;

  Future<Map<String, Anime>> fetchAnime() async{
    final Uri dataUrl = urlHelper.buildUrl(_category[_categoryCode], _gridNum.toString(), _offset.toString(), _currentlyAiring, _searchText);
    final response = await http.get(dataUrl);
    final responseJson = json.decode(response.body);
    Map<String, Genre> genreList = Map();

    for(var value in responseJson['included']){
      Genre genre = Genre.fromJson(value);
      genreList.putIfAbsent(genre.id, () => genre);
    }

    _loading = false;
    for (var value in responseJson['data']){
      Anime anime = Anime.fromJson(value, genreList);
      _animeList.putIfAbsent(anime.id, () => anime);
      _loading = true;
    }

    return _animeList;
  }

  Drawer _buildMyDrawer(){
    Widget _drawerHeader = Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            width: 200.0,
            height: 200.0,
            child: CircleAvatar(
              backgroundImage: AssetImage("images/at.png"),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text("Anithing", style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),),
          )
        ],
      ),
      decoration: BoxDecoration(color: Colors.blue),
    );

    Widget _searchBar = Container(
      padding: const EdgeInsets.only(left:  20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 10.0, color: Colors.blue),
          left: BorderSide(width: 10.0, color: Colors.blue),
          right: BorderSide(width: 10.0, color: Colors.blue)
        )
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search Anime",
          border: InputBorder.none,
          icon: Icon(Icons.search)
        ),
        onSubmitted: (String text){
          setState(() {
            _animeList.clear();
            _offset = 0;
            _categoryCode = 0;
            _currentlyAiring = false;
            _searchText = text;
            Navigator.pop(context);
          });
        },
      ),
    );

    Widget _popularAnimeItemMenu = _buildAnimeMenuTab("Popular Anime", 0, false);
    Widget _topRatedAnimeItemMenu = _buildAnimeMenuTab("Top Rated Anime", 1, false);
    Widget _currentlyAiringAnimeItemMenu = _buildAnimeMenuTab("Currently Airing Anime", 0, true);

    return Drawer(
      child: ListView(
        children: <Widget>[
          _drawerHeader,
          _searchBar,
          Divider(),
          _popularAnimeItemMenu,
          _topRatedAnimeItemMenu,
          _currentlyAiringAnimeItemMenu
        ],
      ),
    );
  }

  ListTile _buildAnimeMenuTab(String itemName, int code, bool airing){
    return ListTile(
      title: Padding(padding: const EdgeInsets.only(left: 20.0, top: 0.0, bottom: 0.0),child: Text(itemName, style: TextStyle(color: Colors.blue),),),
      onTap: (){
        setState(() {
          _animeList.clear();
          _offset = 0;
          _categoryCode = code;
          _currentlyAiring = airing;
          _searchText = null;
          Navigator.pop(context);
        });
      },
    );
  }

  Widget buildSliverGridView(AsyncSnapshot<Map<String, Anime>> snapshot){
    ScrollController _scrollController = new ScrollController();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        setState((){
          _offset += _gridNum;
        });
      }
    });

    SliverGridDelegate myGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 0.6,
    );

    SliverChildBuilderDelegate myBuildDelegate = SliverChildBuilderDelegate(
            (BuildContext context, int index){
          return _buildGridTile(snapshot.data, index);
        },
        childCount: _animeList.length
    );

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: myGridDelegate,
          delegate: myBuildDelegate,
        ),
        SliverToBoxAdapter(
          child: _loading ? Container(padding: const EdgeInsets.all(10.0), child: Center(child: CircularProgressIndicator(),),) : Container(child: null,),
        ),
      ],
    );
  }

  _buildGridTile(Map<String, Anime> animeList, int index){

    Anime currentAnime = animeList.values.elementAt(index);

    return GridTile(
      child: InkWell(
        child: Hero(
          tag: currentAnime.title,
          child: Card(
            color: Colors.blueAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(imageUrl: currentAnime.posterImage),
                Expanded(child: Center(
                    child: Text(
                      currentAnime.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 11.0, color: Colors.white, fontWeight: FontWeight.bold),)
                ),
                )
              ],
            ),
          ),
        ),
        onTap: (){
          Navigator.push(context, new MyCustomRoute(
              builder: (context) => new DetailPage(anime: currentAnime)
          ));
        },
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appTitle),
        ),
        drawer: _buildMyDrawer(),
        body: FutureBuilder<Map<String, Anime>>(
          future: fetchAnime(),
          builder: (context, snapshot){
            if(_animeList.length > 0){
              print("masuk " + _animeList.length.toString());
              return buildSliverGridView(snapshot);
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
    );
  }
}