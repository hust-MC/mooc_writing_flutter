import 'package:flutter/material.dart';

class FavoriteGesture extends StatefulWidget {
  static const double defaultSize = 100;
  final Widget child;
  final double size;

  const FavoriteGesture({required this.child, this.size = defaultSize, Key? key}) : super(key: key);

  @override
  State<FavoriteGesture> createState() => _FavoriteGestureState();
}

class _FavoriteGestureState extends State<FavoriteGesture> {
  final GlobalKey _key = GlobalKey();
  bool inFavorite = false;

  Offset temp = Offset.zero;

  Offset _globalToLocal(Offset global) {
    RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(global);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: _key,
        child: Stack(children: [
          widget.child,
          if (inFavorite)
            Positioned(
              top: temp.dy - widget.size / 2,
              left: temp.dx - widget.size / 2,
              child: Icon(Icons.favorite, size: widget.size, color: Colors.redAccent),
            )
        ]),
        onDoubleTapDown: (details) {
          temp = _globalToLocal(details.globalPosition);
        },
        onDoubleTap: () {
          setState(() {
            inFavorite = true;
          });
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              inFavorite = false;
            });
          });
        });
  }
}
