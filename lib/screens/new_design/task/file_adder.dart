import 'dart:io';

import 'package:PTasker/models/project.dart';
import 'package:PTasker/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class FileAdder extends StatefulWidget {
  final String path;

  const FileAdder({Key key, @required this.path}) : super(key: key);

  @override
  _FileAdderState createState() => _FileAdderState();
}

class _FileAdderState extends State<FileAdder> {
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'Image',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.image,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'image';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Audio',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.audiotrack,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'audio';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Video',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.video_label,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'video';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'PDF',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.pages,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'pdf';
                });
                filePicker(context);
              },
            ),
            ListTile(
              title: Text(
                'Others',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.attach_file,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'others';
                });
                filePicker(context);
              },
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageViewer()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Firestorage Demo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.image);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.audio);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'video') {
        file = await FilePicker.getFile(type: FileType.video);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'pdf') {
        file = await FilePicker.getFile(
            type: FileType.custom, allowedExtensions: ['pdf']);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.any);
        fileName = p.basename(file.path);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance.ref().child("${widget.path}/$filename");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    print("URL is $url");
  }
}

class ImageViewer extends StatefulWidget {
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Viewer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
    );
  }
}
