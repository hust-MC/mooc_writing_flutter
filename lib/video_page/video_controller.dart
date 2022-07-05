import 'dart:convert';

import 'package:mc/video_page/server_data.dart';
import 'package:mc/video_page/video_model.dart';

class VideoController {
  late List<VideoModel> dataList;

  void init() {
    dataList = fetchVideoData();
  }

  // 缺点：
  // 1、需要针对json的每个字段创建get方法，一旦字段多了会非常繁琐
  // 2、需要保证map的字段和json的字段完全一致， 容易出错

  // 从服务端拉取视频Json字符串类型表示的视频数据
  List<VideoModel> fetchVideoData() {
    List<VideoModel> list = (jsonDecode(ServerData.data) as List<dynamic>).map((e) => VideoModel.fromJson(e)).toList();
    return list;
  }
}
