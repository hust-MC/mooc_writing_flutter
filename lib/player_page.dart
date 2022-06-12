import 'package:flutter/material.dart';
import 'package:player/player.dart';
import 'package:player/video_view.dart';

class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  static const String url = 'https://sample-videos.com/video123/flv/240/big_buck_bunny_240p_10mb.flv';

  String version = 'null';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var player = Player();
    player.setCommonDataSource(url, autoPlay: true);
    return VideoView(player);
  }
}
