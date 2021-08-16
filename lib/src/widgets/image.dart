
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';

class ImageTapWrapper extends StatelessWidget {
  const ImageTapWrapper({
    this.imageProvider,
    this.corner = 0,
    this.size,
  });

  final ImageProvider? imageProvider;
  final double corner;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(corner)),
      child: Container(
        // constraints: BoxConstraints.expand(
        //   height: MediaQuery.of(context).size.height,
        // ),
        child: GestureDetector(
          onTapDown: (_) {
            Navigator.pop(context);
          },
          child: PhotoView(
            imageProvider: imageProvider,
            customSize: size,
          ),
        ),
      ),
    );
  }
}

