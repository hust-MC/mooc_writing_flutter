import 'dart:async';
import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';

class Player extends FijkPlayer {
  static const asset_url_suffix = "asset:///";

  static String _cachePath = '/storage/emulated/0/Android/data/com.example.mc/files';
  bool enableCache = false;

  Player({this.enableCache = false});

  static void setCachePath(String path) {
    _cachePath = path;
  }

  @override
  Future<void> setDataSource(
    String path, {
    bool autoPlay = false,
    bool showCover = false,
  }) async {
    var videoPath = getVideoCachePath(path, _cachePath);
    if (File(videoPath).existsSync()) {
      path = videoPath;
      print("MOOC- play cache video : $path");
    } else if (enableCache) {
      path = 'ijkio:cache:ffio:$path';
      setOption(FijkOption.formatCategory, "cache_file_path", getVideoCachePath(path, _cachePath));
      print("MOOC- play http with cache: $path");
    } else {
      print("MOOC- play http : $path");
    }

    super.setDataSource(path, autoPlay: autoPlay, showCover: showCover);
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

String getVideoCachePath(String url, String cachePath) {
  Uri uri = Uri.parse(url);
  String name = uri.pathSegments.last;
  var path = '$cachePath/$name';
  print('MOOC-get vido path: $path');

  return path;
}

enum SourceType { net, asset }
