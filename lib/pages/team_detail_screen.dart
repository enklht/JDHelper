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
              spacing: 20,
              children: [
                const Text("基礎データ", style: TextStyle(fontSize: 20)),
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
                        DataCell(Text(team.year?.toString() ?? "不明")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("人数")),
                        DataCell(Text(team.memberNum?.toString() ?? "不明")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("種類")),
                        DataCell(Text(team.kind ?? "不明")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("テーマ")),
                        DataCell(Text(team.theme ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("キャラクター")),
                        DataCell(Text(team.characters ?? "")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("備考")),
                        DataCell(Text(team.note ?? "")),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("構成", style: TextStyle(fontSize: 20)),
                DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        "パート",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "道具",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: team.program
                          ?.map(
                            (e) => DataRow(
                              cells: [
                                DataCell(Text(e.$1)),
                                DataCell(Text(e.$2)),
                              ],
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
