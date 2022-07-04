import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/services.dart';

class Player extends FijkPlayer {
  static const asset_url_suffix = "asset:///";

  String? cachePath;
  bool enableCache = false;

  Player({this.cachePath, this.enableCache = false});

  @override
  Future<void> setDataSource(
    String path, {
    bool autoPlay = false,
    bool showCover = false,
  }) async {
    path = 'ijkio:cache:ffio:$path';
    super.setDataSource(path, autoPlay: autoPlay, showCover: showCover);
    setOption(FijkOption.formatCategory, "cache_file_path", '/storage/emulated/0/1.tmp'); //每首歌的临时文件名自己根据自己需要生成就行了。
  }

  void setCommonDataSource(
    String url, {
    SourceType type = SourceType.net,
    bool autoPlay = false,
    bool showCover = false,
  }) {
    if (type == SourceType.asset && !url.startsWith(asset_url_suffix)) {
      url = asset_url_suffix + url;
    }
    setDataSource(url, autoPlay: autoPlay, showCover: showCover);
  }
}

enum SourceType { net, asset }
