import 'dart:convert';

class VideoController {
  // 本地mock数据，实际上是模拟网络数据
  static const _serverData = """{
    "title": "示例视频",
    "url": "https://sample-videos.com/video123/flv/240/big_buck_bunny_240p_10mb.flv",
    "playCount": 88
}""";

  Map<String, dynamic> _videoData = {};

  void init() {
    _videoData = fetchVideoData();
  }

  String get title => _videoData['title'];
  String get url => _videoData['url'];
  int get playCount => _videoData['playCount'];

  // 从服务端拉取视频Json字符串类型表示的视频数据
  Map<String, dynamic> fetchVideoData() {
    return jsonDecode(_serverData);
  }

}
