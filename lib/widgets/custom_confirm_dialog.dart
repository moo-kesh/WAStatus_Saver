import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status/controller/file_manager.dart';

class CustomConfirmDialogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Permissions denied !',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                'Storage permissions are necessary to access WhatsApp statuses, Please grant permissions or exit application',
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              TextButton(
                  onPressed: () {
                    Permission.storage.request().then((value) {
                      if (value.isGranted) {
                        Provider.of<FilesManager>(context, listen: false)
                            .fetchAllStatuses();
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    'Ask again',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  )),
              Divider(),
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Colors.redAccent, fontSize: 17),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
