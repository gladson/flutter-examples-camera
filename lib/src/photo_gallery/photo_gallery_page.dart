import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples_camera/src/model/gallery.dart';
import 'package:flutter_examples_camera/src/photo_gallery/components/photo_gallery_thumbnail.dart';
import 'package:flutter_examples_camera/src/photo_gallery/components/photo_gallery_wrapper.dart';
import 'package:flutter_examples_camera/src/scripts/dialogs/asset_gif_dialog.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_bloc.dart';
import 'package:flutter_examples_camera/src/photo_gallery/photo_gallery_module.dart';


class PhotoGalleryPage extends StatefulWidget {
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGalleryPage> {
  final PhotoGalleryBloc photoGalleryBlocController = PhotoGalleryModule.to.getBloc<PhotoGalleryBloc>();

  PermissionStatus _status;
  File _imageFile;
  File _imageFile1;
  
  @override
  void initState() {
    super.initState();
    photoGalleryBlocController.checkList() ?? photoGalleryBlocController.clear();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatus);
  }

  void _displayOptionsDialog() async {
    await _optionsDialogBox();
  }

  void _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      imageSelectorCamera();
    } else {
      _updateStatus(status);
    }
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  void imageSelectorCamera() async {
    Navigator.pop(context);
    _imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    File _imageFileCopy = await _imageFile.copy("$tempPath/image$code.png");
    setState(() {
      _imageFile = _imageFileCopy;
      if (photoGalleryBlocController.checkList() != true) {
        photoGalleryBlocController.addFutureList([
          MGallery(
            id: 1,
            name: "image$code",
            file: "${_imageFileCopy.path}"
          )
        ]);
      } else {
        MGallery gallery = photoGalleryBlocController.getList().last;
        photoGalleryBlocController.addM(
          MGallery(
            id: gallery.id + 1,
            name: "image$code",
            file: "${_imageFileCopy.path}"
          )
        );
      }
    });
  }

  void imageSelectorGallery() async {
    Navigator.pop(context);
    _imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var rng = new Random();
    var code = rng.nextInt(1000000) + 100000;
    File _imageFile1Copy = await _imageFile1.copy("$tempPath/image$code.png");
    setState(() {
      _imageFile1 = _imageFile1Copy;
      if (photoGalleryBlocController.checkList() != true) {
        photoGalleryBlocController.addFutureList([
          MGallery(
            id: 1,
            name: "image$code",
            file: "${_imageFile1Copy.path}",
            isSelected: false
          )
        ]);
      } else {
        MGallery gallery = photoGalleryBlocController.getList().last;
        photoGalleryBlocController.addM(
          MGallery(
            id: gallery.id + 1,
            name: "image$code",
            file: "${_imageFile1Copy.path}",
            isSelected: false
          )
        );
      }
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 45,
                        right: 45
                      ),
                      child: FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.camera_enhance,
                              size: 60,
                            ),
                            Text("Tirar foto".toUpperCase()),
                          ],
                        ),
                        onPressed: _askPermission,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 45,
                        right: 45
                      ),
                      child: FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.photo_library,
                              size: 60,
                            ),
                            Text("Galeria".toUpperCase()),
                          ],
                        ),
                        onPressed: imageSelectorGallery,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red)
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void openGalleryPhotoView(BuildContext context, final int index) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) {
          return GalleryPhotoViewWrapper(
            photoGalleryBloc: photoGalleryBlocController,
            backgroundDecoration: BoxDecoration(
              color: Colors.black
            ),
            initialIndex: index,
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: StreamBuilder<List<MGallery>>(
                  stream: photoGalleryBlocController.outPhotoGallery,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<MGallery> gallery = snapshot.data;
                    return GridView.builder(
                      itemCount: gallery.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onLongPress: (){
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AssetGifDialog(
                                  gif: "assets/gif/remover.gif",
                                  fitGif: BoxFit.none,
                                  message: "Tem certeza em deletar este aquivo?",
                                  textCloseButtonIntl: "Cancelar",
                                  fontSizeCloseButtonIntl: [15, 13, 10],
                                  textOkButtonIntl: "Sim",
                                  fontSizeOkButtonIntl: [15, 13, 10],
                                  statusOkButton: true,
                                  pressedOkButton: (){
                                    setState(() {
                                      gallery.removeAt(index);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }
                            );
                          },
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: GalleryItemThumbnail(
                                galleryItem: gallery[index],
                                onTap: (){
                                  for (var item in gallery) {
                                    item.isSelected = false;
                                  }
                                  gallery[index].isSelected = true;
                                  openGalleryPhotoView(
                                    context,
                                    gallery[index].id
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ),
            ),
            Center(
              child: _imageFile == null ? 
              Text("Nenhuma imagem selecionada!".toUpperCase()) : 
              Image.file(
                _imageFile,
                scale: 2.5,
              ),
            ),
            RaisedButton(
              onPressed: () {
                _displayOptionsDialog();
              },
              child: Text('Clique aqui!'.toUpperCase()),
            )
          ],
        ),
      ),
    );
  }
}
