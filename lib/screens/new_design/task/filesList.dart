import 'dart:io';

import 'package:PTasker/models/file_meta.dart';
import 'package:PTasker/services/storage.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FilesList extends StatefulWidget {
  final List<FileMeta> files;
  final bool allowAdding;
  final bool allowDelete;

  final Future<void> Function(FileMeta) onFileTap;
  final Future<void> Function(FileMeta) onFileDelete;
  final Future<void> Function() onFileAdd;

  const FilesList({
    this.files,
    bool allowAdding,
    bool allowDelete,
    this.onFileTap,
    this.onFileDelete,
    this.onFileAdd,
  })  : this.allowAdding = allowAdding ?? false,
        this.allowDelete = allowDelete ?? false;

  @override
  _FilesListState createState() => _FilesListState();
}

class _FilesListState extends State<FilesList> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Wrap(
        children: widget.files.map(
          (e) {
            return GestureDetector(
              onTap: () async {
                await widget.onFileTap(e).then((value) => setState(() {}));
              },
              child: Container(
                height: 100,
                width: 100,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      if (widget.allowDelete)
                        GestureDetector(
                          onTap: () async {
                            await widget
                                .onFileDelete(e)
                                .then((value) => setState(() {}));
                          },
                          child: Icon(
                            Icons.close,
                            size: 16.0,
                          ),
                        ),
                      Icon(
                        Icons.assignment,
                        size: 60.0,
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text: e.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
      Visibility(
        visible: widget.allowAdding,
        child: GestureDetector(
          onTap: () async {
            widget.onFileAdd();
          },
          child: Container(
            height: 100,
            width: 100,
            child: Card(
              child: Icon(
                Icons.add,
                size: 60.0,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
