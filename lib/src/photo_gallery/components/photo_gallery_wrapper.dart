import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:flutter_examples_camera/src/model/gallery.dart';
import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_bloc.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
    {
      this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      @required this.photoGalleryBloc
    }
  ) : pageController = PageController( initialPage: initialIndex );

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final PhotoGalleryBloc photoGalleryBloc;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  List<MGallery> galleryItems;
  int currentIndex;
  
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    galleryItems = widget.photoGalleryBloc.getList();
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: galleryItems.length,
              loadingChild: widget.loadingChild,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                  onPressed: (){
                    setState(() {
                      print(galleryItems);
                      if (galleryItems != null) {
                        galleryItems.removeWhere((item) => item.id == widget.initialIndex);
                        widget.photoGalleryBloc.removeId(widget.initialIndex);
                      } else {
                        galleryItems.clear();
                        widget.photoGalleryBloc.clear();
                      }
                      Navigator.of(context).pop();
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black45,
                  child: Text(
                    "Imagem - ${currentIndex + 1}".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 17.0, decoration: null),
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final MGallery item = galleryItems[index];
    return item.isSelected
    ? PhotoViewGalleryPageOptions.customChild(
        child: Container(
          width: 300,
          height: 300,
          child: 
          Image.file(
            File(item.file), height: 200.0
          ),
        ),
        childSize: const Size(300, 300),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
        maxScale: PhotoViewComputedScale.covered * 1.1,
        heroAttributes: PhotoViewHeroAttributes(tag: item.id),
      )
    : PhotoViewGalleryPageOptions(
      imageProvider: FileImage(File(item.file)),//AssetImage(item.file),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}