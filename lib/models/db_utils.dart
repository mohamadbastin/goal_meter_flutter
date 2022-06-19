import 'dart:developer';

import 'package:progress_tracker/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void addToLastID() async {
  final prefs = await SharedPreferences.getInstance();
  final int? counter = prefs.getInt('lastId');
  if (counter == null) {
    await prefs.setInt('lastId', 1);
  } else {
    await prefs.setInt('lastId', counter + 1);
  }
}

void goalAddOne(Goal g) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? gl = prefs.getStringList(g.id.toString());
  if (gl != null) {
    List<String> gl2 = [gl[0], gl[1], gl[2]];
    gl2.add((int.parse(gl[3]) + 1).toString());
    await prefs.setStringList(g.id.toString(), gl2);
    log("updated goal");
  }
}

void goalMinusOne(Goal g) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? gl = prefs.getStringList(g.id.toString());
  if (gl != null) {
    List<String> gl2 = [gl[0], gl[1], gl[2]];
    gl2.add((int.parse(gl[3]) - 1).toString());
    await prefs.setStringList(g.id.toString(), gl2);
    log("updated goal");
  }
}

void goalDelete(Goal g) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(g.id.toString());
  List<String>? ids = prefs.getStringList("ids");
  if (ids != null) {
    ids.removeWhere((element) => element == g.id.toString());
    await prefs.setStringList("ids", ids);
    log("deleted goal");
  }
}

void setLastIDToZero() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('lastId', 0);
}

void setLastIDAndUpdateList(id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('lastId', id);
  List<String>? ids = prefs.getStringList("ids");
  if (ids != null) {
    ids.add(id.toString());
    await prefs.setStringList("ids", ids);
  } else {
    List<String> idss = [id.toString()];
    await prefs.setStringList("ids", idss);
  }
  log("updated last id and list ");
}

void setGoal(id, g) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(id.toString(), g);
  log("added goal");
}
