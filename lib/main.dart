import 'dart:developer';
import 'dart:math' as rdd;

import 'package:flutter/material.dart';
import 'package:progress_tracker/widgets/addGoalDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/db_utils.dart';
import 'models/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GOAL METER | Progress Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int lastId;
  late List<Goal> goals;

  Future<Map> getData() async {
    final prefs = await SharedPreferences.getInstance();

    final int? counter = prefs.getInt('lastId');
    lastId = counter ?? -1;

    final List<String>? ids = prefs.getStringList("ids");

    List<Goal> gs = [];
    log(ids.toString(), name: "IDs");
    ids?.forEach((element) {
      final List<String>? gl = prefs.getStringList(element);
      // log(gl.toString());

      Goal g = Goal(
          id: int.parse(element),
          title: gl![1],
          goal: int.parse(gl[2]),
          state: int.parse(gl[3]));
      gs.add(g);
    });

    return {"lastId": lastId, "goals": gs};
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log("asdf", name: "build");
    return FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // lastId = snapshot.data! as int;
            log(snapshot.data.toString(), name: "build");
            lastId = snapshot.data!["lastId"];
            goals = snapshot.data!["goals"];
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          goals.length,
                          (index) => Column(
                                children: [
                                  goalCard(goals[index], update),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider()
                                ],
                              )),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addGoalDialog(lastId + 1);
                    }).then((_) => setState(() {})),
                tooltip: 'Add Goal',
                child: const Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Widget goalCard(Goal g, update) {
  final random = rdd.Random();
  var list = [
    Colors.redAccent,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.tealAccent
  ];
  return Row(
    children: [
      SizedBox(width: 200, child: Text(g.title)),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Container(
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: const Text(""),
                ),
                Container(
                  width: 500 * (g.state / g.goal),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: list[random.nextInt(list.length)],
                  ),
                  child: const Text(""),
                ),
              ],
            ),
            Row(
              children: [
                Text(g.state.toString()),
                const Text(" / "),
                Text(g.goal.toString())
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      goalAddOne(g);
                      update();
                    },
                    icon: const Icon(
                      Icons.plus_one,
                      color: Colors.green,
                      size: 28,
                    )),
                const Text("  "),
                IconButton(
                    onPressed: () {
                      goalMinusOne(g);
                      update();
                    },
                    icon: const Icon(
                      Icons.exposure_minus_1,
                      color: Colors.red,
                      size: 28,
                    )),
                const Text("  "),
                IconButton(
                    onPressed: () {
                      goalDelete(g);
                      update();
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                      size: 28,
                    )),
              ],
            )
          ],
        ),
      ),
    ],
  );
}
