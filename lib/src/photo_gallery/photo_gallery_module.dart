import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_bloc.dart';
import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_page.dart';

class PhotoGalleryModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
    Bloc((i) => PhotoGalleryBloc()),
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => PhotoGalleryPage();

  static Inject get to => Inject<PhotoGalleryModule>.of();
}
