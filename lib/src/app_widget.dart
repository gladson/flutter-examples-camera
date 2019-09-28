import 'package:flutter/material.dart';

import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: PhotoGalleryModule(),
    );
  }
}
