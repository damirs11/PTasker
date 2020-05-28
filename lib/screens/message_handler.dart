import 'dart:async';
import 'dart:io';
import 'package:PTasker/services/notification.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, bool> pushNotificationsBool;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
        future: PushNotificationService().notificationStatus,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          return Column(
            children: <Widget>[
              SwitchListTile(
                activeColor: Colors.blue,
                contentPadding: const EdgeInsets.all(0),
                value: snapshot.data['onCreateProjectNotification'],
                title: Text("При создании проекта"),
                onChanged: (val) {
                  setState(() {
                    if (!snapshot.data['onCreateProjectNotification']) {
                      PushNotificationService()
                          .subtopic("onCreateProjectNotification");
                    } else {
                      PushNotificationService()
                          .unsubtopic("onCreateProjectNotification");
                    }
                  });
                },
              ),
              SwitchListTile(
                activeColor: Colors.blue,
                contentPadding: const EdgeInsets.all(0),
                value: false,
                title: Text("Received newsletter"),
                onChanged: null,
              ),
              SwitchListTile(
                activeColor: Colors.blue,
                contentPadding: const EdgeInsets.all(0),
                value: true,
                title: Text("Received Offer Notification"),
                onChanged: (val) {},
              ),
              SwitchListTile(
                activeColor: Colors.blue,
                contentPadding: const EdgeInsets.all(0),
                value: true,
                title: Text("Received App Updates"),
                onChanged: null,
              ),
            ],
          );
        });
  }
}
