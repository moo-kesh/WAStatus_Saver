import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/utils/utils.dart';
import 'package:whatsapp_status/widgets/custom_floating_button.dart';
import 'package:whatsapp_status/widgets/custom_grid_view_tile.dart';
import 'package:whatsapp_status/widgets/no_status_background.dart';

const InActive = Colors.greenAccent;
const Active = Color(0xFF00E676);

class LiveStatusScreen extends StatefulWidget {
  @override
  _LiveStatusScreenState createState() => _LiveStatusScreenState();
}

class _LiveStatusScreenState extends State<LiveStatusScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScaleTransition(
        alignment: Alignment.bottomCenter,
        scale: _hideFabAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeColor == Active
                          ? activeColor = InActive
                          : activeColor = Active;
                      inactiveColor = InActive;

                      category == CategoryTypes.all ||
                              category == CategoryTypes.vidOnly
                          ? category = CategoryTypes.imgOnly
                          : category = CategoryTypes.all;
                    });
                  },
                  child: CustomFloatingButton(
                    label: 'Images',
                    icon: Icons.image_rounded,
                    activeColor: activeColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      inactiveColor == Active
                          ? inactiveColor = InActive
                          : inactiveColor = Active;
                      activeColor = InActive;

                      category == CategoryTypes.all ||
                              category == CategoryTypes.imgOnly
                          ? category = CategoryTypes.vidOnly
                          : category = CategoryTypes.all;
                    });
                  },
                  child: CustomFloatingButton(
                    label: 'Videos',
                    icon: Icons.video_collection_rounded,
                    activeColor: inactiveColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Consumer<FilesManager>(
            builder: (context, fileManager, child) {
              if (fileManager.liveStatusesMap.isEmpty) {
                return Center(
                  child: JumpingDotsProgressIndicator(),
                );
              } else if (fileManager.liveStatusesMap[category].isEmpty) {
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
                        itemCount: fileManager.liveStatusesMap[category].length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (fileManager.liveStatusesMap[category].isEmpty) {
                            return NoStatusesWidget();
                          } else
                            return CustomGridViewTile(
                              data: fileManager.liveStatusesMap[category]
                                  [index],
                              context: context,
                              isShowFavoriteButton: false,
                              statusType: StatusTypes.live,
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
