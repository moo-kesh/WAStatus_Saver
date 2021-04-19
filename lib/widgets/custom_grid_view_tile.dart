import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/models/status_model.dart';
import 'package:whatsapp_status/screen/media_player.dart';
import 'package:whatsapp_status/styles/color_styles.dart';
import 'package:whatsapp_status/utils/shared_pref_util.dart';
import 'package:whatsapp_status/utils/utils.dart';

class CustomGridViewTile extends StatefulWidget {
  CustomGridViewTile(
      {@required this.data,
      @required this.context,
      this.isShowFavoriteButton,
      this.statusType});
  final StatusModel data;
  final BuildContext context;
  final bool isShowFavoriteButton;
  final statusType;
  @override
  _CustomGridViewTileState createState() => _CustomGridViewTileState();
}

class _CustomGridViewTileState extends State<CustomGridViewTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.greenAccent, borderRadius: BorderRadius.circular(22)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(alignment: Alignment.center, children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                child: Hero(
                  tag: widget.data.path,
                  child: Stack(alignment: Alignment.topRight, children: [
                    Image.file(
                      widget.data.fileThumb,
                      height: Size.infinite.height,
                      width: Size.infinite.width,
                      fit: BoxFit.fill,
                    ),
                    if (widget.isShowFavoriteButton)
                      GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            child: CircleAvatar(
                              backgroundColor:
                                  Colors.greenAccent.withOpacity(0.5),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: widget.data.isFavorite
                                    ? favoriteColor
                                    : unFavoriteColor,
                                size: 26,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (widget.data.isFavorite) {
                                SharedPrefUtil.removeSharedPref(
                                    widget.data.fileName);
                                widget.data.isFavorite = false;
                                Provider.of<FilesManager>(context,
                                        listen: false)
                                    .removeFromFavoritesList(widget.data);
                                Fluttertoast.showToast(
                                    msg: 'Removed from favorites!',
                                    backgroundColor:
                                        Colors.pink.withOpacity(0.7));
                              } else {
                                SharedPrefUtil.setSharedPrefs(
                                    widget.data.path, widget.data.fileName);
                                widget.data.isFavorite = true;
                                Provider.of<FilesManager>(context,
                                        listen: false)
                                    .addToFavoritesList(widget.data);
                                Fluttertoast.showToast(
                                    msg: 'Added to favorites!',
                                    backgroundColor:
                                        Colors.pink.withOpacity(0.7));
                              }
                            });
                          }),
                  ]),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MediaPlayer(widget.data)));
                },
              ),
            ),
            if (widget.data.fileType == StatusModel.VIDEO)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MediaPlayer(widget.data)));
                },
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  size: 60,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
          ]),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white.withOpacity(0.8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Icon(Icons.share_rounded,
                      color: Colors.greenAccent.shade400, size: 32),
                  onTap: () {
                    Share.shareFiles([widget.data.path]);
                  },
                ),
                widget.data.isSaved
                    ? GestureDetector(
                        child: widget.statusType == StatusTypes.live
                            ? Icon(Icons.download_done_rounded,
                                color: Colors.greenAccent.shade400, size: 32)
                            : Icon(Icons.delete_forever_rounded,
                                color: Colors.greenAccent.shade400, size: 32),
                        onTap: () {
                          setState(() {
                            Provider.of<FilesManager>(context, listen: false)
                                .deleteStatus(widget.data);
                          });
                        },
                      )
                    : GestureDetector(
                        child: Icon(Icons.download_rounded,
                            color: Colors.greenAccent.shade400, size: 32),
                        onTap: () {
                          setState(() {
                            if (!widget.data.isSaved) {
                              Provider.of<FilesManager>(context, listen: false)
                                  .saveStatus(widget.data);
                            }
                          });
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
