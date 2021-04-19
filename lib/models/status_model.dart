import 'dart:io';

class StatusModel {
  File fileThumb;
  String fileName;
  int fileSize;
  String fileType;
  String path;
  bool isFavorite = false;
  bool isSaved;

  static const String IMAGE = 'image';
  static const String VIDEO = 'video';

  StatusModel.savedStatuses(this.path, this.fileName, this.fileSize,
      this.fileThumb, this.fileType, this.isFavorite, this.isSaved);

  StatusModel.liveStatuses(this.path, this.fileName, this.fileSize,
      this.fileThumb, this.fileType, this.isSaved);

  String get name => fileName;

  int get size => fileSize;

  File get thumbnail => fileThumb;

  bool get isFileSaved => isSaved;
}
