import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_examples_camera/src/model/gallery.dart';


class PhotoGalleryBloc extends BlocBase {
  PhotoGalleryBloc();
  
  BehaviorSubject<List<MGallery>> _photoGalleryController = BehaviorSubject<List<MGallery>>();
  
  //saida
  Stream<List<MGallery>> get outPhotoGallery => _photoGalleryController.stream;
  //entrada
  Sink<List<MGallery>> get inPhotoGallery => _photoGalleryController.sink;

  clear() {
    if (_photoGalleryController.value != null) {
      _photoGalleryController.value.clear();
    }
  }

  removeId(int id) {
    if (_photoGalleryController.value != null) {
      _photoGalleryController.value.removeWhere((item) => item.id == id);
    }
  }

  List<MGallery> getList() {
    return _photoGalleryController.value.toList();
  }

  bool checkList() {
    try {
      return _photoGalleryController.value.length > 0 ? true : false;
    } catch (e) {
      return false;
    }
  }

  addFutureList(List<MGallery> listFPeople) async {
    _photoGalleryController.sink.add(listFPeople);
  }

  addM(MGallery mClients) {
    _photoGalleryController.value.add(mClients);
  }
  
  @override
  void dispose() {
    _photoGalleryController.close();
    super.dispose();
  }
}
