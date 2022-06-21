import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RightMenu {

  static Future showRightMenu(BuildContext context, dx, dy,
      {required List<MapEntry<String, dynamic>> items, required Size size, required Widget menu}) async {
    double sw = MediaQuery.of(context).size.width; //屏幕宽度
    double sh = MediaQuery.of(context).size.height; //屏幕高度
    Border border = dy < sh / 2
        ? //
        Border(top: BorderSide(color: Colors.green[200]!, width: 2))
        : Border(bottom: BorderSide(color: Colors.green[200]!, width: 2));
//如果传了items参数则根据items生成菜单
    if (items != null && items.length > 0) {
      double itemWidth = 100.0;
      double itemHeight = 50.0;
      double menuHeight = itemHeight * items.length + 2;

      size = Size(itemWidth, menuHeight);

      menu = Container(
        decoration: BoxDecoration(color: Colors.white, border: border),
        child: Column(
          children: items
              .map<Widget>((e) => InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: itemWidth,
                      height: itemHeight,
                      child: Text(
                        e.key,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, e.value);
                    },
                  ))
              .toList(),
        ),
      );
    }
    Size sSize = MediaQuery.of(context).size;

// PopupMenuItem

    double menuW = size.width; //菜单宽度
    double menuH = size.height; //菜单高度
    //判断手势位置在屏幕的那个区域以判断最好的弹出方向
    double endL = dx < sw / 2 ? dx : dx - menuW;
    double endT = dy < sh / 2 ? dy : dy - menuH;
    double endR = dx < sw / 2 ? dx + menuW : dx;
    double endB = dy < sh / 2 ? dy + menuH : dy;

    return await showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          //由于用了组件放大的动画效果，所以用了SingleChildScrollView包裹
          //否则在组件小的时候会出现菜单超出编辑的错误
          return SingleChildScrollView(child: menu);
        },
        barrierColor: Colors.grey.withOpacity(0),
        //弹窗后的背景遮罩色，调来调去还是透明的顺眼
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 200),
        //动画时间

        transitionBuilder: (context, anim1, anim2, child) {
          return Stack(
            children: [
              // 有好多种Transition来实现不同的动画效果，可以参考官方API
              PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromSize(
                        //动画起始位置与元素大小
                        Rect.fromLTWH(dx, dy, 1, 1),
                        sSize),
                    end: RelativeRect.fromSize(
                        //动画结束位置与元素大小
                        Rect.fromLTRB(endL, endT, endR, endB),
                        sSize),
                  ).animate(CurvedAnimation(parent: anim1, curve: Curves.ease)),
                  child: child)
            ],
          );
        });
  }
}
