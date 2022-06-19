import 'package:flutter/material.dart';

import '../models/db_utils.dart';

Widget addGoalDialog(int id, context) {
  TextEditingController title = TextEditingController();
  TextEditingController goalc = TextEditingController();
  TextEditingController stepc = TextEditingController();

  // addToLastID();
  // setLastIDToZero();

  return AlertDialog(
    content: Container(
      width: 400,
      height: 900,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Add a Goal"),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text("Title"), TextField(controller: title)],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Goal"),
                  TextField(
                    controller: goalc,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("State"),
                  TextField(
                    controller: stepc,
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  // goal = goalc.text as int;
                  // state = stepc.text as int;

                  setLastIDAndUpdateList(id);

                  List<String> g = [
                    id.toString(),
                    title.text,
                    goalc.text,
                    stepc.text
                  ];

                  setGoal(id, g);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 130,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: const Center(
                    child: Text("ADD"),
                  ),
                ),
              )
            ],
          )),
    ),
  );
}
