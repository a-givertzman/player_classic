import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
///
class PlayVideoFromYoutube extends StatefulWidget {
  final String _title;
  final TextEditingController _idController;
  ///
  ///
  const PlayVideoFromYoutube({
    Key? key,
    required String title,
    required TextEditingController idController
  }) : 
    _title = title,
    _idController = idController,
    super(key: key);
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState(
    title: _title,
    idController: _idController,
  );
}
///
///
class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  String _url = '';
  String _title;
  final TextEditingController _idController;
  YoutubePlayerController? _videoController;
  ///
  ///
  _PlayVideoFromYoutubeState({
    required String title,
    required TextEditingController idController
  }):
    _title = title,
    _idController = idController;
  //
  //
  @override
  void initState() {
    _url = _idController.text;
    _videoController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );    
    _idController.addListener(() {
        final videoId = _idController.text;
        _url = 'http://youtu.be/$videoId';
        _title = _idController.text;
        print('url: $_url');
        _videoController?.loadVideoById(videoId: videoId);
        // setState(() {});
    });
    super.initState();
  }
  //
  //
  @override
  void dispose() {
    _videoController?.close();
    super.dispose();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final videoController = _videoController;
    if (videoController != null) {
      return YoutubePlayer(
        controller: _videoController!,
        aspectRatio: 16 / 9,
      );
    }
    return Column(
      children: [
        const CircularProgressIndicator(),
        Text('$_title...')
      ],
    );
  }
}
