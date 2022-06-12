import 'package:flutter/material.dart';
import 'package:player/player.dart';
import 'package:player/video_view.dart';

class VideoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  static const String url = 'asset/videos/test.flv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
          itemCount: 15,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.75),
            itemBuilder: (context, index) {
              return VideoView(
                  Player()..setCommonDataSource(url, type: SourceType.asset, autoPlay: true, showCover: true));
            }));
  }
}
