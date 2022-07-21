import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'favorite_animation_icon.dart';

class VideoGesture extends StatefulWidget {
  const VideoGesture({
    required Key key,
    required this.child,
    required this.onAddFavorite,
    required this.onSingleTap,
  }) : super(key: key);

  final Function onAddFavorite;
  final Function onSingleTap;
  final Widget child;

  @override
  State<VideoGesture> createState() => _VideoGestureState();
}

class _VideoGestureState extends State<VideoGesture> {
  final GlobalKey _key = GlobalKey();

  List<Offset> icons = [];
  Offset temp = Offset.zero;

  // 内部转换坐标点
  Offset _globalToLocal(Offset p) {
    RenderBox getBox = _key.currentContext!.findRenderObject() as RenderBox;
    return getBox.globalToLocal(p);
  }

  @override
  Widget build(BuildContext context) {
    var iconStack = Stack(
      children: icons
          .map<Widget>(
            (p) => FavoriteAnimationIcon(
              key: Key(p.toString()),
              position: p,
              onAnimationComplete: () {
                icons.remove(p);
              },
            ),
          )
          .toList(),
    );
    return RawGestureDetector(
      gestures: {
        AllowDoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowDoubleTapGestureRecognizer>(
            () => AllowDoubleTapGestureRecognizer(), (AllowDoubleTapGestureRecognizer instance) {
          instance.onDoubleTap = () {
            setState(() {
              icons.add(temp);
            });
          };
        }),
        AllowTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowTapGestureRecognizer>(
          () => AllowTapGestureRecognizer(),
          (AllowTapGestureRecognizer instance) {
            instance.onTapDown = (detail) {
              temp = _globalToLocal(detail.globalPosition);
            };
          },
        )
      },
      behavior: HitTestBehavior.opaque,
      key: _key,
      child: Stack(
        children: <Widget>[
          widget.child,
          iconStack,
        ],
      ),
    );
  }
}

class AllowDoubleTapGestureRecognizer extends DoubleTapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class AllowTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
