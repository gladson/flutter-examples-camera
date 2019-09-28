import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_examples_camera/src/model/gallery.dart';

class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail(
      {Key key, this.galleryItem, this.onTap})
      : super(key: key);

  final MGallery galleryItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.id,
          child: Image.file(
            File(galleryItem.file), 
            height: 200.0
          ),
        ),
      )
    );
  }
}