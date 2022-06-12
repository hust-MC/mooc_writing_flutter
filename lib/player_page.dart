import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  static const String url = 'https://sample-videos.com/video123/flv/240/big_buck_bunny_240p_10mb.flv';

  @override
  Widget build(BuildContext context) {
    var player = FijkPlayer()..setDataSource(url, autoPlay: true);
    return Scaffold(body: FijkView(player: player));
  }
}
