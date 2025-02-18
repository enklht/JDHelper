import "package:flutter/material.dart";
import "package:street_performance_helper/models/trick.dart";

class TrickDetail extends StatelessWidget {
  const TrickDetail({required this.trick});
  final Trick trick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trick.name),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              spacing: 20,
              children: [
                const Text("基礎データ", style: TextStyle(fontSize: 20)),
                _dataTable(context),
                const SizedBox(height: 20),
                const Text("演技例", style: TextStyle(fontSize: 20)),
                _routineTable(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataTable(BuildContext context) {
    return DataTable(
      headingRowHeight: 0,
      columns: const [
        DataColumn(label: Text("属性")),
        DataColumn(label: Text("値")),
      ],
      rows: [
        DataRow(
          cells: [
            const DataCell(Text("技名")),
            DataCell(Text(trick.name)),
          ],
        ),
        DataRow(
          cells: [
            const DataCell(Text("道具")),
            DataCell(Text(trick.prop)),
          ],
        ),
        DataRow(
          cells: [
            const DataCell(Text("タグ")),
            DataCell(Text(trick.tags.toString())),
          ],
        ),
      ],
    );
  }

  Widget _routineTable(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            "チーム名",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "パート",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      rows: trick.performances
          .map(
            (e) => DataRow(
              cells: [
                DataCell(Text(e.$1)),
                DataCell(Text(e.$2)),
              ],
            ),
          )
          .toList(),
    );
  }
}
