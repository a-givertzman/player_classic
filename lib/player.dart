import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
///
class PlayVideoFromYoutube extends StatefulWidget {
  final String _title;
  final TextEditingController _idController;
  final void Function()? _onEnded;
  ///
  ///
  const PlayVideoFromYoutube({
    Key? key,
    required String title,
    required TextEditingController idController,
    void Function()? onEnded,
  }) : 
    _title = title,
    _idController = idController,
    _onEnded = onEnded,
    super(key: key);
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState(
    title: _title,
    idController: _idController,
    onEnded: _onEnded,
  );
}
///
///
class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  String _url = '';
  String _title;
  final TextEditingController _idController;
  final void Function()? _onEnded;
  YoutubePlayerController? _videoController;
  ///
  ///
  _PlayVideoFromYoutubeState({
    required String title,
    required TextEditingController idController,
    void Function()? onEnded,
  }):
    _title = title,
    _idController = idController,
    _onEnded = onEnded;
  //
  //
  @override
  void initState() {
    _videoController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    if (_idController.text.isNotEmpty) {
      final videoId = _idController.text;
      _url = 'http://youtu.be/$videoId';
      _videoController?.loadVideoById(videoId: videoId);
    }
    _idController.addListener(() {
        final videoId = _idController.text;
        _url = 'http://youtu.be/$videoId';
        _title = _idController.text;
        print('url: $_url');
        _videoController?.loadVideoById(videoId: videoId).then((_) {
        });
        _videoController?.duration.whenComplete(() {
          print('Duration complitted');
        });
    });
    // _videoController?.playerState.asStream().listen((event) {
    //   print('event: $event');
    //   if (event == PlayerState.ended) {
    //     print('Ended');
    //     final onEnded = _onEnded;
    //     if (onEnded != null) {
    //       onEnded();
    //     }
    //   }
    // });
    _videoController?.videoStateStream.listen((event) {
      _videoController?.playerState.then((state) {
        print('state: $state');
        if (event == PlayerState.ended) {
          print('Ended');
          final onEnded = _onEnded;
          if (onEnded != null) {
            onEnded();
          }
        }
      });
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
