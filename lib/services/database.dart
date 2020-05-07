import 'dart:developer';

import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('usersData');
  final CollectionReference tasksCollection =
      Firestore.instance.collection('tasks'); //TODO: Удалить потом
  final CollectionReference projectsCollection =
      Firestore.instance.collection('projects');

  //GET
  Stream<List<UserData>> get usersData {
    return usersCollection.snapshots().map(_userDataListFromSnapshot);
  }

  Stream<UserData> get userDataStream {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<UserData> get userData {
    return usersCollection.document(uid).get().then(_userDataFromSnapshot);
  }

  // Stream<List<Task>> get tasks {
  //   //TODO: Удалить потом
  //   return tasksCollection.snapshots().map(_tasksListFromSnapshot);
  // }

  // Stream<Task> get task {
  //   //TODO: Удалить потом
  //   return tasksCollection.document(uid).snapshots().map(_taskFromSnapshot);
  // }

  Stream<List<Project>> get projects {
    return projectsCollection.snapshots().map(_projectListFromSnapshot);
  }

  Stream<Project> get project {
    return projectsCollection
        .document(uid)
        .snapshots()
        .map(_projectFromSnapshot);
  }

  //UPDATE
  Future updateUserData(UserData userData) async {
    return await usersCollection.document(uid).setData(userData.toJson());
  }

  // Future updateTask(Task task) async {
  //   //TODO: Удалить потом
  //   return await tasksCollection.document(task.uid).setData(task.toJson());
  // }

  Future updateProject(Project project) async {
    return await projectsCollection
        .document(project.uid)
        .setData(project.toJson());
  }

  //utils--------------
  List<UserData> _userDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData.fromJson(doc.data);
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData.fromJson(snapshot.data);
  }

  // List<Task> _tasksListFromSnapshot(QuerySnapshot snapshot) {
  //   //TODO: Удалить потом
  //   return snapshot.documents.map((doc) {
  //     return Task.fromJson(doc.data);
  //   }).toList();
  // }

  // Task _taskFromSnapshot(DocumentSnapshot snapshot) {
  //   //TODO: Удалить потом
  //   return Task.fromJson(snapshot.data);
  // }

  List<Project> _projectListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var temp = Project.fromJson(doc.data);
      return temp;
    }).toList();
  }

  Project _projectFromSnapshot(DocumentSnapshot snapshot) {
    return Project.fromJson(snapshot.data);
  }

  //Fake data
  void createProjectsWithData() {
    DateTime now = new DateTime.now().toUtc();
    var newDate30 = now.add(new Duration(days: 30));
    var newDate60 = now.add(new Duration(days: 60));

    Task p1task1 = new Task(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 1",
      priority: TaskPriority.low,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );
    Task p1task2 = new Task(
      authorUid: "hqfFsw7OgfUnqqzhSHal2p0r9Hn2",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 1",
      priority: TaskPriority.medium,
      status: TaskStatus.open,
      dateOfCompletion: newDate60,
    );

    Task p2task1 = new Task(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 2",
      priority: TaskPriority.high,
      status: TaskStatus.open,
      dateOfCompletion: newDate60,
    );
    Task p2task2 = new Task(
      authorUid: "hSisTQ1jdDbFrOoUh3YM29BqSYl1",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 2",
      priority: TaskPriority.low,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );

    Task p3task1 = new Task(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 3",
      priority: TaskPriority.medium,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );
    Task p3task2 = new Task(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 3",
      priority: TaskPriority.high,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );

    Project project_1 = new Project(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      description: "Описание проекта, его целей и тд",
      name: "Проект #1",
      relatedTasks: [p1task1, p1task2],
      relatedUserUids: {
        'hqfFsw7OgfUnqqzhSHal2p0r9Hn2': true,
        'kdAGJ042HmVHprI1UmX68CiBe7J3': false
      },
      dateOfCompletion: p1task2.dateOfCompletion,
    );
    Project project_2 = new Project(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      description: "Описание проекта, его целей и тд",
      name: "Проект #2",
      relatedTasks: [p2task1, p2task2],
      relatedUserUids: {
        'hqfFsw7OgfUnqqzhSHal2p0r9Hn2': false,
        'kdAGJ042HmVHprI1UmX68CiBe7J3': true
      },
      dateOfCompletion: p2task1.dateOfCompletion,
    );
    Project project_3 = new Project(
      authorUid: "kdAGJ042HmVHprI1UmX68CiBe7J3",
      description: "Описание проекта, его целей и тд",
      name: "Проект #3",
      relatedTasks: [p3task1, p3task2],
      relatedUserUids: {
        'hqfFsw7OgfUnqqzhSHal2p0r9Hn2': false,
        'kdAGJ042HmVHprI1UmX68CiBe7J3': false
      },
      dateOfCompletion: p1task1.dateOfCompletion,
    );

    this.updateProject(project_1);
    this.updateProject(project_2);
    this.updateProject(project_3);
  }
}
