import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/screen/favorite_statuses.dart';
import 'package:whatsapp_status/screen/live_statuses.dart';
import 'package:whatsapp_status/screen/saved_statuses.dart';
import 'package:whatsapp_status/styles/themes.dart';
import 'package:whatsapp_status/widgets/custom_confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
  @override
  void initState() {
    handlePermissions();
    super.initState();
  }

  void handlePermissions() async {
    if (await Permission.storage.isGranted) {
      Provider.of<FilesManager>(context, listen: false).fetchAllStatuses();
    } else {
      Permission.storage.request().then((value) {
        if (value.isGranted) {
          Provider.of<FilesManager>(context, listen: false).fetchAllStatuses();
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomConfirmDialogBox());
          CustomConfirmDialogBox();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Themes.lightTheme.copyWith(
            tabBarTheme: TabBarTheme(
                labelColor: Colors.green,
                unselectedLabelColor: Colors.greenAccent.withOpacity(0.5),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(color: Colors.white),
                unselectedLabelStyle:
                    TextStyle(color: Colors.greenAccent.withOpacity(0.5)),
                indicator: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50)))),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Hero(
                        tag: 'appIcon',
                        child: ImageIcon(
                          Image.asset('assets/graphics/appbar_icon.png').image,
                          color: Colors.greenAccent,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'WAStatus Saver',
                        style: GoogleFonts.lato(
                          color: Colors.greenAccent,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.pinkAccent,
                          size: 30,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteStatuses()));
                      },
                    ),
                    /*GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.help_rounded,
                        size: 30,
                        color: Colors.greenAccent,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: Dialog(child: CustomDialogBox()),
                            );
                          });
                    },
                  )*/
                  ],
                  bottom: TabBar(
                      indicatorWeight: 0,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.greenAccent.withOpacity(0.7)),
                      tabs: [
                        tabBarItem(Icons.live_tv_rounded, 'Live'),
                        tabBarItem(Icons.save_alt_rounded, 'Saved')
                      ]),
                ),
                body:
                    Provider.of<FilesManager>(context).savedStatusesList != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TabBarView(children: [
                              LiveStatusScreen(),
                              SavedStatusScreen()
                            ]),
                          )
                        : Container(
                            color: Colors.white,
                          ))));
  }
}

Widget tabBarItem(IconData icon, String title) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.greenAccent, width: 0.7)),
    child: Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}
