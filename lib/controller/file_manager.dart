import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:whatsapp_status/models/status_model.dart';
import 'package:whatsapp_status/utils/shared_pref_util.dart';

enum CategoryTypes { all, imgOnly, vidOnly }
enum WhatsAppTypes { WhatsApp, WhatsAppBusiness }

const String whatsAppStatusesPath =
    '/storage/emulated/0/WhatsApp/Media/.Statuses/';
const String whatsAppBusinessStatusesPath =
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses/';
const String savedStatusesPath = '/storage/emulated/0/WAStatus Saver/';

class FilesManager extends ChangeNotifier {
  List<StatusModel> liveStatusesList = [];
  List<StatusModel> savedStatusesList = [];
  List<StatusModel> favoritesStatusesList = [];

  HashMap<CategoryTypes, List<StatusModel>> liveStatusesMap =
      HashMap<CategoryTypes, List<StatusModel>>();
  HashMap<CategoryTypes, List<StatusModel>> savedStatusesMap =
      HashMap<CategoryTypes, List<StatusModel>>();

  static WhatsAppTypes defaultWhatsapp = WhatsAppTypes.WhatsApp;

  List<StatusModel> get getLiveStatusesList {
    return liveStatusesList;
  }

  List<StatusModel> get getSavedStatusesList {
    return savedStatusesList;
  }

  bool isWhatsAppInstalled() {
    return Directory(whatsAppStatusesPath).existsSync();
  }

  bool isWhatsAppBusinessInstalled() {
    return Directory(whatsAppBusinessStatusesPath).existsSync();
  }

  void fetchAllStatuses(WhatsAppTypes type) async {
    if (await Permission.storage.isGranted) {
      fetchLiveStatuses(type);
      fetchSavedStatuses();
    } else {
      Permission.storage.request().then((value) async {
        if (value.isGranted) {
          fetchLiveStatuses(type);
          fetchSavedStatuses();
        }
      });
    }
    notifyListeners();
  }

  void fetchFavoriteStatuses() async {
    for (StatusModel data in savedStatusesList) {
      if (await SharedPrefUtil.isAvailable(data.fileName)) {
        favoritesStatusesList.add(data);
      }
    }
  }

  void fetchLiveStatuses(WhatsAppTypes whatsAppTypes) async {
    liveStatusesList.clear();
    if (Directory(whatsAppTypes == WhatsAppTypes.WhatsApp
            ? whatsAppStatusesPath
            : whatsAppBusinessStatusesPath)
        .existsSync()) {
      await for (FileSystemEntity item in (Directory(
              whatsAppTypes == WhatsAppTypes.WhatsApp
                  ? whatsAppStatusesPath
                  : whatsAppBusinessStatusesPath)
          .list())) {
        if (!item.path.contains('.nomedia')) {
          //skip .nomedia files
          liveStatusesList.add(StatusModel.liveStatuses(
              item.path,
              basename(item.path),
              getFileSize(File(item.path)),
              await getThumbnail(File(item.path)),
              getFileType(File(item.path)),
              isSaved(item.path)));
        }
      }
      categorizeAllStatuses();
      notifyListeners();
    }
  }

  void fetchSavedStatuses() async {
    if (!Directory(savedStatusesPath).existsSync()) {
      Directory(savedStatusesPath).create();
    }
    savedStatusesList.clear();
    for (FileSystemEntity item
        in (await Directory(savedStatusesPath).list().toList())) {
      if (!item.path.contains('.nomedia')) {
        //skip .nomedia files
        savedStatusesList.add(StatusModel.savedStatuses(
            item.path,
            basename(item.path),
            getFileSize(File(item.path)),
            await getThumbnail(File(item.path)),
            getFileType(File(item.path)),
            await isFavorite(basename(item.path)),
            isSaved(item.path)));
      }
    }
    categorizeAllStatuses();
    fetchFavoriteStatuses();
    notifyListeners();
  }

  void saveStatus(StatusModel data) async {
    if (File(savedStatusesPath + basename(data.path)).existsSync()) {
      Fluttertoast.showToast(
        msg: 'Status already saved!',
      );
    } else {
      if (!Directory(savedStatusesPath).existsSync()) {
        Directory(savedStatusesPath).create();
      }
      File(whatsAppStatusesPath + basename(data.path))
          .copy(savedStatusesPath + basename(data.path))
          .then((value) async {
        savedStatusesList.add(StatusModel.savedStatuses(
            value.path,
            basename(value.path),
            getFileSize(value),
            await getThumbnail(value),
            getFileType(value),
            await isFavorite(basename(value.path)),
            true));
        data.isSaved = true;
        categorizeSavedStatuses();
        notifyListeners();
      });
      Fluttertoast.showToast(
          msg: 'Status saved!',
          backgroundColor: Colors.greenAccent.withOpacity(0.7));
    }
  }

  void deleteStatus(StatusModel data) {
    File(savedStatusesPath + data.fileName).delete();
    data.isSaved = false;
    changeStatusOfLiveStatusesObject(data);
    savedStatusesList.remove(getDeletableObject(data));
    favoritesStatusesList.remove(removeableFavoritesObject(data));
    SharedPrefUtil.removeSharedPref(data.fileName);
    Fluttertoast.showToast(
        msg: 'Status removed!',
        backgroundColor: Colors.redAccent.withOpacity(0.7));
    categorizeSavedStatuses();
    notifyListeners();
  }

  // ignore: missing_return
  StatusModel removeableFavoritesObject(StatusModel object) {
    for (StatusModel item in favoritesStatusesList) {
      if (item.path.contains(object.fileName)) {
        return item;
      }
    }
  }

  void changeStatusOfLiveStatusesObject(StatusModel object) {
    for (StatusModel item in liveStatusesList) {
      if (item.path.contains(object.fileName)) {
        item.isSaved = false;
      }
    }
  }

  // ignore: missing_return
  StatusModel getDeletableObject(StatusModel object) {
    for (StatusModel statusObject in savedStatusesList) {
      if (statusObject.path.contains(object.fileName)) {
        return statusObject;
      }
    }
  }

  void addToFavoritesList(StatusModel data) {
    SharedPrefUtil.setSharedPrefs(data.path, data.fileName);
    favoritesStatusesList.add(data);
    notifyListeners();
  }

  void removeFromFavoritesList(StatusModel data) {
    SharedPrefUtil.removeSharedPref(data.fileName);
    favoritesStatusesList.remove(data);
    notifyListeners();
  }

  Future<File> getThumbnail(File file) async => file.path.contains('.mp4')
      ? await VideoCompress.getFileThumbnail(file.path)
      : File(file.path);

  int getFileSize(File file) => (file.lengthSync() ~/ 1024 ~/ 1024);

  String getFileType(File file) =>
      file.path.contains('.mp4') ? StatusModel.VIDEO : StatusModel.IMAGE;

  Future<bool> isFavorite(String fileName) async =>
      await SharedPrefUtil.isAvailable(fileName);

  List<StatusModel> getImgOnly(List<StatusModel> list1) {
    List<StatusModel> list = [];
    for (StatusModel data in list1) {
      if (data.fileType == StatusModel.IMAGE) {
        list.add(data);
      }
    }
    return list;
  }

  List<StatusModel> getVidOnly(List<StatusModel> list1) {
    List<StatusModel> list = [];
    for (StatusModel data in list1) {
      if (data.fileType == StatusModel.VIDEO) {
        list.add(data);
      }
    }
    return list;
  }

  bool isSaved(String path) {
    return File(savedStatusesPath + basename(path)).existsSync();
  }

  void categorizeAllStatuses() {
    categorizeLiveStatuses();
    categorizeSavedStatuses();
  }

  void categorizeLiveStatuses() {
    liveStatusesMap.clear();
    liveStatusesMap[CategoryTypes.all] = liveStatusesList;
    liveStatusesMap[CategoryTypes.imgOnly] = getImgOnly(liveStatusesList);
    liveStatusesMap[CategoryTypes.vidOnly] = getVidOnly(liveStatusesList);
  }

  void categorizeSavedStatuses() {
    savedStatusesMap.clear();
    savedStatusesMap[CategoryTypes.all] = savedStatusesList;
    savedStatusesMap[CategoryTypes.imgOnly] = getImgOnly(savedStatusesList);
    savedStatusesMap[CategoryTypes.vidOnly] = getVidOnly(savedStatusesList);
  }
}
