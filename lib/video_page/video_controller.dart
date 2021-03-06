import 'dart:convert';

import 'package:mc/video_page/server_data.dart';
import 'package:mc/video_page/video_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      var list = jsonDecode(modelStr) as List<dynamic>;
      // jsonDecode获取到的是“List<Map>”，需要转换成List<VideoModel>
      // List<Map> => List<VideoModel>

      return list.map((e) => VideoModel.fromJson(e)).toList();
    } else {
      // 二级缓存未找到数据，走三级缓存
      var list = jsonDecode(ServerData.fetchDataFromServer()) as List<dynamic>;
      var sp = await SharedPreferences.getInstance();
      sp.setString('videoModel', ServerData.fetchDataFromServer());
      print('MOOC- 3/fetch data from server');

      return list.map((e) => VideoModel.fromJson(e)).toList();
    }
  }
}
