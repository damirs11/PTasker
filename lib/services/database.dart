import 'dart:developer';

import 'package:PTasker/models/comment.dart';
import 'package:PTasker/models/file_meta.dart';
import 'package:PTasker/models/project.dart';
import 'package:PTasker/models/enums/task_priority_enum.dart';
import 'package:PTasker/models/enums/task_status_enum.dart';
import 'package:PTasker/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PTasker/models/task_model.dart';
import 'package:PTasker/models/user.dart';

class DatabaseService {
  final String uid;
  final String subuid;
  DatabaseService({this.uid, this.subuid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('usersData');
  final CollectionReference projectsCollection =
      Firestore.instance.collection('projects');
  final CollectionReference fileMetaCollection =
      Firestore.instance.collection('filemeta');

  //GET
  Future<List<UserData>> get usersData {
    return usersCollection.getDocuments().then(_userDataListFromSnapshot);
  }

  Future<UserData> getUserData(userUid) async {
    return usersCollection.document(userUid).get().then(_userDataFromSnapshot);
  }

  Stream<List<UserData>> get usersDataStream {
    return usersCollection.snapshots().map(_userDataListFromSnapshot);
  }

  Stream<UserData> get userDataStream {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<UserData> get currUserData async {
    var authUser = await AuthService().getUser;
    return usersCollection
        .document(authUser.uid)
        .get()
        .then(_userDataFromSnapshot);
  }

  Stream<List<Task>> get tasks {
    return projectsCollection
        .document(uid)
        .collection("tasks")
        .snapshots()
        .map(_tasksListFromSnapshot);
  }

  Stream<Task> get task {
    return projectsCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .snapshots()
        .map(_taskFromSnapshot);
  }

  Future<Task> get getTask {
    return projectsCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .get()
        .then(_taskFromSnapshot);
  }

  Stream<List<Project>> get projects {
    log("Projects taken");
    return projectsCollection.snapshots().map(_projectListFromSnapshot);
  }

  Future<List<Project>> get getProjects {
    log("Projects taken");
    return projectsCollection.getDocuments().then(_projectListFromSnapshot);
  }

  Stream<Project> get project {
    log("Project taken $uid");
    return projectsCollection
        .document(uid)
        .snapshots()
        .map(_projectFromSnapshot);
  }

  Stream<List<FileMeta>> getRelatedFilesMeta() {
    return fileMetaCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .collection("relatedFiles")
        .snapshots()
        .map(_fileMetaListFromSnapshot);
  }

  Future<List<Comment>> getComments() {
    return projectsCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .collection("comments")
        .getDocuments()
        .then(_commetsFromSnapshot);
  }

  //UPDATE
  Future updateUserData(UserData userData) async {
    return await usersCollection.document(uid).setData(userData.toJson());
  }

  Future updateTask(Project project, Task task) async {
    return await projectsCollection
        .document(project.uid)
        .collection("tasks")
        .document(task.uid)
        .setData(task.toJson());
    // return await tasksCollection.document(task.uid).setData(task.toJson());
  }

  Future updateProject(Project project) async {
    return await projectsCollection
        .document(project.uid)
        .setData(project.toJson());
  }

  Future updateRelatedFileMeta(FileMeta fileMeta) async {
    return await fileMetaCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .collection("relatedFiles")
        .document(fileMeta.name)
        .setData(fileMeta.toJson());
  }

  // Future updateCommentFileMeta(FileMeta fileMeta) async {
  //   return await fileMetaCollection
  //       .document(uid)
  //       .collection("tasks")
  //       .document(subuid)
  //       .collection("comments")
  //       .document(fileMeta.uid)
  //       .setData(fileMeta.toJson());
  // }

  //DELELTE
  Future<void> deleteProject(Project project) async {
    projectsCollection
        .document(project.uid)
        .delete()
        .then((value) => print('Project ${project.uid} deleted'));
  }

  Future<void> deleteTask(Project project, Task task) async {
    projectsCollection
        .document(project.uid)
        .collection("tasks")
        .document(task.uid)
        .delete()
        .then((value) => print('Task ${task.uid} from ${project.uid} deleted'));
  }

  Future<void> deleteRelatedFileMeta(FileMeta fileMeta) async {
    await fileMetaCollection
        .document(uid)
        .collection("tasks")
        .document(subuid)
        .collection("relatedFiles")
        .document(fileMeta.name)
        .delete();
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

  List<Task> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task.fromJson(doc.data);
    }).toList();
  }

  Task _taskFromSnapshot(DocumentSnapshot snapshot) {
    return Task.fromJson(snapshot.data);
  }

  List<Project> _projectListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var temp = Project.fromJson(doc.data);
      return temp;
    }).toList();
  }

  Project _projectFromSnapshot(DocumentSnapshot snapshot) {
    return Project.fromJson(snapshot.data);
  }

  List<FileMeta> _fileMetaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return FileMeta.fromJson(doc.data);
    }).toList();
  }

  List<Comment> _commetsFromSnapshot(QuerySnapshot snapshot) {
    var temp = snapshot.documents.map((e) {
      return Comment.fromJson(e.data);
    }).toList();
    temp.map((e) async {
      e.user = await getUserData(e.userUid);
    }).toList();
    return temp;
  }

  //Fake data
  void createProjectsWithData() {
    DateTime now = new DateTime.now().toUtc();
    var newDate30 = now.add(new Duration(days: 30));
    var newDate60 = now.add(new Duration(days: 60));

    Task p1task1 = new Task(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 1",
      priority: TaskPriority.low,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );
    Task p1task2 = new Task(
      authorUid: "Qi8Uukwi8xMlaj9gTnFIc6WyPZ82",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 1",
      priority: TaskPriority.medium,
      status: TaskStatus.open,
      dateOfCompletion: newDate60,
    );

    Task p2task1 = new Task(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 2",
      priority: TaskPriority.high,
      status: TaskStatus.open,
      dateOfCompletion: newDate60,
    );
    Task p2task2 = new Task(
      authorUid: "sKLh1jgBmvVfMwk5g4mZc7TULzF3",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 2",
      priority: TaskPriority.low,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );

    Task p3task1 = new Task(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      title: "Название задачи 1",
      mainText: "Описание задачи номер 1 проекта 3",
      priority: TaskPriority.medium,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );
    Task p3task2 = new Task(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      title: "Название задачи 2",
      mainText: "Описание задачи номер 2 проекта 3",
      priority: TaskPriority.high,
      status: TaskStatus.open,
      dateOfCompletion: newDate30,
    );

    Project project_1 = new Project(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      description: "Описание проекта, его целей и тд",
      name: "Проект #1",
      relatedUserUids: {
        'Qi8Uukwi8xMlaj9gTnFIc6WyPZ82': true,
        'sKLh1jgBmvVfMwk5g4mZc7TULzF3': false
      },
      dateOfCompletion: p1task2.dateOfCompletion,
    );
    Project project_2 = new Project(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      description: "Описание проекта, его целей и тд",
      name: "Проект #2",
      relatedUserUids: {
        'Qi8Uukwi8xMlaj9gTnFIc6WyPZ82': false,
        'sKLh1jgBmvVfMwk5g4mZc7TULzF3': true
      },
      dateOfCompletion: p2task1.dateOfCompletion,
    );
    Project project_3 = new Project(
      authorUid: "7QxI2gFzLyTB2aUBAAmJFqFCwGT2",
      description: "Описание проекта, его целей и тд",
      name: "Проект #3",
      relatedUserUids: {
        'Qi8Uukwi8xMlaj9gTnFIc6WyPZ82': false,
        'sKLh1jgBmvVfMwk5g4mZc7TULzF3': false
      },
      dateOfCompletion: p1task1.dateOfCompletion,
    );

    this.updateProject(project_1);
    this.updateTask(project_1, p1task1);
    this.updateTask(project_1, p1task2);

    this.updateProject(project_2);
    this.updateTask(project_2, p2task1);
    this.updateTask(project_2, p2task2);

    this.updateProject(project_3);
    this.updateTask(project_3, p3task1);
    this.updateTask(project_3, p3task2);
  }
}
