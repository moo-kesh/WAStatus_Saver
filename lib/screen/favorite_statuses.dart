import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/widgets/custom_grid_view_tile.dart';
import 'package:whatsapp_status/widgets/no_status_background.dart';

const InActive = Colors.greenAccent;
const Active = Color(0xFF00E676);

class FavoriteStatuses extends StatefulWidget {
  @override
  _FavoriteStatusesState createState() => _FavoriteStatusesState();
}

class _FavoriteStatusesState extends State<FavoriteStatuses>
    with TickerProviderStateMixin {
  Color activeColor = InActive;
  Color inactiveColor = InActive;
  CategoryTypes category;

  AnimationController _hideFabAnimation;
  @override
  initState() {
    super.initState();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    category = CategoryTypes.all;
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_rounded),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Consumer<FilesManager>(
            builder: (context, fileManager, child) {
              print('length: ' +
                  fileManager.favoritesStatusesList.length.toString());
              if (fileManager.favoritesStatusesList.isEmpty) {
                return NoStatusesWidget();
              } else
                return Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScrollNotification,
                    child: GridView.builder(
                        primary: false,
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1.3 / 1.45,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        scrollDirection: Axis.vertical,
                        itemCount: fileManager.favoritesStatusesList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CustomGridViewTile(
                            data: fileManager.favoritesStatusesList[index],
                            context: context,
                            isShowFavoriteButton: true,
                          );
                        }),
                  ),
                );
            },
          ),
        ]),
      ),
    );
  }
}
