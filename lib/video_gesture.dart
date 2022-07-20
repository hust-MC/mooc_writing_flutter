import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

  // 内部转换坐标点
  Offset _p(Offset p) {
    RenderBox getBox = _key.currentContext!.findRenderObject() as RenderBox;
    return getBox.globalToLocal(p);
  }

  List<Offset> icons = [];

  bool canAddFavorite = false;
  bool justAddFavorite = false;
  Timer? timer;

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
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowMultipleGestureRecognizer>(
          () => AllowMultipleGestureRecognizer(),
          (AllowMultipleGestureRecognizer instance) {
            instance.onTap = () => print('MCLOG===tap on parent ');
            instance.onTapDown = (detail) {
              setState(() {
                if (canAddFavorite) {
                  icons.add(_p(detail.globalPosition));
                  widget.onAddFavorite.call();
                  justAddFavorite = true;
                } else {
                  justAddFavorite = false;
                }
              });
            };
            instance.onTapUp = (detail) {
              timer?.cancel();
              var delay = canAddFavorite ? 600 : 300;
              timer = Timer(Duration(milliseconds: delay), () {
                canAddFavorite = false;
                timer = null;
                if (!justAddFavorite) {
                  widget.onSingleTap.call();
                }
              });
              canAddFavorite = true;
            };
            instance.onTapCancel = () {
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

class FavoriteAnimationIcon extends StatefulWidget {
  final Offset position;
  final double size;
  final Function onAnimationComplete;

  const FavoriteAnimationIcon({
    required Key key,
    required this.onAnimationComplete,
    required this.position,
    this.size = 100,
  }) : super(key: key);

  @override
  FavoriteAnimationIconState createState() => FavoriteAnimationIconState();
}

class FavoriteAnimationIconState extends State<FavoriteAnimationIcon> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animationController?.addListener(() {
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  startAnimation() async {
    await _animationController?.forward();
    widget.onAnimationComplete.call();
  }

  double rotate = pi / 10.0 * (2 * Random().nextDouble() - 1);

  double get value => _animationController?.value ?? 0;

  double appearDuration = 0.1;
  double dismissDuration = 0.8;

  double get opa {
    if (value < appearDuration) {
      return 0.99 / appearDuration * value;
    }
    if (value < dismissDuration) {
      return 0.99;
    }
    var res = 0.99 - (value - dismissDuration) / (1 - dismissDuration);
    return res < 0 ? 0 : res;
  }

  double get scale {
    if (value < appearDuration) {
      return 1 + appearDuration - value;
    }
    if (value < dismissDuration) {
      return 1;
    }
    return (value - dismissDuration) / (1 - dismissDuration) + 1;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      Icons.favorite,
      size: widget.size,
      color: Colors.redAccent,
    );
    content = ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft.add(Alignment(0.66, 0.66)),
        colors: const [
          Color(0xffEE6E6E),
          Color(0xffF03F3F),
        ],
      ).createShader(bounds),
      child: content,
    );
    Widget body = Transform.rotate(
      angle: rotate,
      child: Opacity(
        opacity: opa,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: scale,
          child: content,
        ),
      ),
    );
    return widget.position == null
        ? Container()
        : Positioned(
            left: widget.position.dx - widget.size / 2,
            top: widget.position.dy - widget.size / 2,
            child: body,
          );
  }
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
