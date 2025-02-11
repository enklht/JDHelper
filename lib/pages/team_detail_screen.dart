import "package:flutter/material.dart";
import "package:street_performance_helper/models/team.dart";

class TeamDetail extends StatelessWidget {
  final Team team;
  const TeamDetail({required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
      ),
      body: Center(
        child: Table(
          children: [
            TableRow(children: [const Text("チーム名"), Text(team.name)]),
            TableRow(children: [const Text("年度"), Text(team.year.toString())]),
            TableRow(
              children: [const Text("人数"), Text(team.memberNum.toString())],
            ),
            TableRow(children: [const Text("種別"), Text(team.kind)]),
          ],
        ),
      ),
    );
  }
}
