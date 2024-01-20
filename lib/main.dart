import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:player_classic/player.dart';
// import 'package:player_classic/pod_player.dart';

void main() {
  runApp(const MyApp());
}
///
///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});
  //
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
///
///
class MyHomePage extends StatefulWidget {
  final String title;
  ///
  ///
  const MyHomePage({super.key, required this.title});
  //
  //
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller;
  final TextEditingController _videoIdController;
  List<SearchResult> _searchResult = [];
  String? _nextPageToken;
  ///
  ///
  _MyHomePageState():
    _controller = TextEditingController.fromValue(
      const TextEditingValue(text: ''),
    ),
    _videoIdController = TextEditingController();
    // .fromValue(
      // const TextEditingValue(text: 'https://youtu.be/hecoYVmBTcU?si=kCeWlr4kM1cUITD4'),
      // const TextEditingValue(text: 'hecoYVmBTcU?si=kCeWlr4kM1cUITD4'),
    // );
  //
  //
  @override
  Widget build(BuildContext context) {
    final titleSyle = Theme.of(context).textTheme.bodyLarge;
    final subTitleSyle = Theme.of(context).textTheme.bodySmall;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          // title: Text(widget.title),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'search',
                    ),
                    onSubmitted: (value) {
                      _search(_controller.text);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _search(_controller.text);
                }, 
                icon: const Icon(Icons.search),
              )
            ],
          ),
          if (_videoIdController.text.isNotEmpty) Flexible(
            child: PlayVideoFromYoutube(
              title: _videoIdController.text,
              idController: _videoIdController,
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                final item = _searchResult[index];
                final title = item.snippet?.title;
                final channel = item.snippet?.channelTitle;
                final videoId = item.id?.videoId;
                final idKind = item.id?.kind;
                final thumbnail = item.snippet?.thumbnails?.default_?.url;
                return ListTile(
                  leading: CircleAvatar(
                    child: (thumbnail != null) ? Image.network(thumbnail) : null
                  ),
                  title: Text('$title', style: titleSyle,),
                  subtitle: Text('$channel | $idKind', style: subTitleSyle),
                  trailing: const Icon(Icons.navigate_next),
                  dense: true,
                  onTap: () {
                    if (videoId != null) {
                      setState(() {
                        _videoIdController.text = videoId;
                      });
                    }
                  },
                );
              }
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
  ///
  ///
  void _search(String query) {
    print('query: $query');
    _apiRequest(query, 'AIzaSyBMo9lSzMvWtL62bJrKZ53DFN5eQ-T4AW8', null).then((searchResult) {
      setState(() {
        _searchResult = searchResult;
      });
    });
  }
  ///
  ///
  Future<List<SearchResult>> _apiRequest(String query, String apiKey, String? pageToken) async {
    List<SearchResult> items = [];
    final httpClient = clientViaApiKey(apiKey);
    final type = [
      // 'channel',
      // 'playlist',
      'video',
    ];
    print('Search...');
    try {
      final api = YouTubeApi(httpClient);
      final results = await api.search.list(['id', 'snippet'], q: query, maxResults: 1000, pageToken: pageToken, type: type);
      _nextPageToken = results.nextPageToken;
      items = results.items!;
      print('Received ${items.length}');
      for (final file in items) {
        print(file);
      }
    } catch (err) {
      print('Search error $err');
    } finally {
      httpClient.close();
    }
    print('Search - finished');
    return items;
  }
}
