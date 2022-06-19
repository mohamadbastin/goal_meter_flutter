class Goal {
  Goal(
      {required this.id,
      required this.title,
      required this.goal,
      this.state = 0});

  String title;
  int goal;
  int state;
  int id;
}
