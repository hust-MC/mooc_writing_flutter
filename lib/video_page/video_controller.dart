import 'dart:convert';

import 'package:mc/video_page/server_data.dart';
import 'package:mc/video_page/video_model.dart';

class VideoController {
  List<VideoModel>? dataList;

  Future<void> init() async {
    // 首先判断一级缓存——即内存中是否有数据
    print('MOOC- init video controller');
    if (dataList == null) {
      print('MOOC- model is null');
      // 如果没有，则从二级/三级缓存查找
      dataList = await fetchVideoData();
    }
  }

  // 缺点：
  // 1、需要针对json的每个字段创建get方法，一旦字段多了会非常繁琐
  // 2、需要保证map的字段和json的字段完全一致， 容易出错

  // 从服务端拉取视频Json字符串类型表示的视频数据
  Future<List<VideoModel>> fetchVideoData() async {
    var sp = await SharedPreferences.getInstance();
    var modelStr = sp.getString("videoModel");
    if (modelStr != null && modelStr.isNotEmpty) {
      // 二级缓存中找到数据，直接使用
      print('MOOC- 2/use sp data');
      List<VideoModel> list = (jsonDecode(modelStr) as List<dynamic>).map((e) => VideoModel.fromJson(e)).toList();
      return list;
    } else {
      // 二级缓存未找到数据，走三级缓存
      var model = jsonDecode(ServerData.fetchDataFromServer());
      var sp = await SharedPreferences.getInstance();
      sp.setString('videoModel', ServerData.fetchDataFromServer());
      print('MOOC- 3/fetch data from server');
      List<VideoModel> list = (model as List<dynamic>).map((e) => VideoModel.fromJson(e)).toList();
      return list;
    }
  }
}
