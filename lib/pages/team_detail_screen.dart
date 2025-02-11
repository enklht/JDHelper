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
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Text("基礎データ", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                DataTable(
                  headingRowHeight: 0,
                  columns: const [
                    DataColumn(label: Text("属性")),
                    DataColumn(label: Text("値")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("チーム名")),
                        DataCell(Text(team.name)),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("年度")),
                        DataCell(Text(team.year.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("人数")),
                        DataCell(Text(team.memberNum.toString())),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("種類")),
                        DataCell(Text(team.kind)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("構成", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                DataTable(
                  columns: const [
                    DataColumn(label: Text("パート")),
                    DataColumn(label: Text("道具")),
                  ],
                  rows: team.program
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.$1)),
                            DataCell(Text(e.$2)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
