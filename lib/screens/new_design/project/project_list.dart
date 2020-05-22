import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/user.dart';
import 'package:PTasker/screens/new_design/project/project_edit_create.dart';
import 'package:PTasker/screens/new_design/task/task_list.dart';
import 'package:PTasker/screens/new_design/task/task_page_builder.dart';
import 'package:PTasker/services/database.dart';
import 'package:PTasker/shared/loading.dart';
import 'package:PTasker/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // _getToolbar(context),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Проекты ',
                              style: new TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '',
                              style: new TextStyle(
                                  fontSize: 28.0, color: Colors.grey),
                            )
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<UserData>(
                  future: DatabaseService().currUserData,
                  initialData: UserData(),
                  builder: (context, snapshot) {
                    if (snapshot.data.isAdmin) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // DatabaseService().createProjectsWithData();
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ProjectEditCreate(),
                                  ));
                                }, //TODO: Добавить форму добавления
                                iconSize: 30.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text('Добавить проект',
                                  style: TextStyle(color: Colors.black45)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Container(
              height: 360.0,
              padding: EdgeInsets.only(bottom: 25.0),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: StreamBuilder<List<Project>>(
                  stream: DatabaseService().projects,
                  builder: (context, snapshot) {
                    var tSort = (List<Project> p) => p.sort(
                        (a, b) => a.dateOfCreation.compareTo(b.dateOfCreation));

                    if (!snapshot.hasData) {
                      return Center(child: Loading());
                    } else {
                      final List<Project> projects = snapshot.data;
                      tSort(projects);

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(left: 40.0, right: 40.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        // TaskList(project: projects[index]),
                                        TaskPageBuilder(index: index),
                              ));
                            },
                            child: Hero(
                              tag: "hero#mainCard#${projects[index].uid}",
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                color: pColor(projects[index], 1),
                                child: Container(
                                  width: 220.0,
                                  height: 100.0,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.0, bottom: 15.0),
                                          child: Container(
                                            child: Text(
                                              projects[index].name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 50.0),
                                                  color: Colors.white,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                          child: Text(
                                            projects[index].description,
                                            textAlign: TextAlign.justify,
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Padding _getToolbar(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // new Image(
        //     width: 40.0,
        //     height: 40.0,
        //     fit: BoxFit.cover,
        //     image: new AssetImage('assets/list.png')
        // ),
      ]),
    );
  }
}
