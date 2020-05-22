import 'dart:io';

import 'package:PTasker/models/file_meta.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CouldStorageService {
  final String projectUid;
  final String taskUid;

  CouldStorageService({this.projectUid, this.taskUid});

  // Future<dynamic> get allFiles {
  //   StorageReference storageReference;

  //   storageReference = FirebaseStorage.instance.ref().child("$path");

  //   storageReference.
  // }

  Stream<List<FileMeta>> getFilesMeta() {
    return DatabaseService(uid: projectUid, subuid: taskUid)
        .getRelatedFilesMeta();
  }

  Future<void> addRelatedFile(File file) async {
    String filename = p.basename(file.path);

    StorageReference storageReference;
    storageReference = FirebaseStorage.instance
        .ref()
        .child("$projectUid/$taskUid/relatedFiles/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    FileMeta fileMeta = new FileMeta(
      name: filename,
      storagePath: "$projectUid/$taskUid/relatedFiles/$filename",
      url: url,
    );

    DatabaseService(uid: projectUid, subuid: taskUid)
        .updateRelatedFileMeta(fileMeta);

    print("URL is $url");
  }

  Future<void> downloadFile(FileMeta fileMeta) async {
    if (await _checkPermission()) {
      final String tempDir = (await getExternalStorageDirectory()).path;
      // final File file = File('${tempDir.path}/${fileMeta.name}');

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(fileMeta.storagePath);

      final taskId = await FlutterDownloader.enqueue(
        url: await storageReference.getDownloadURL(),
        savedDir: tempDir,
        fileName: fileMeta.name,
        showNotification: true,
        openFileFromNotification: true,
      );
    }
  }

  Future<void> deleteRelatedFile(FileMeta fileMeta) async {
    StorageReference storageReference;
    storageReference =
        FirebaseStorage.instance.ref().child("${fileMeta.storagePath}");

    storageReference.delete().then((_) =>
        DatabaseService(uid: projectUid, subuid: taskUid)
            .deleteRelatedFileMeta(fileMeta));
  }

  Future<String> _findLocalPath(context) async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }
    if (status.isUndetermined || status.isRestricted) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    }
    return false;
  }
}
