import 'package:gsheets/gsheets.dart';
import 'package:street_performance_helper/models/team.dart';

const _cresidentials = String.fromEnvironment("cresidential");
const _spreadsheetId = String.fromEnvironment("spreadsheetId");

class TeamRepository {
  final _gsheets = GSheets(_cresidentials);
  late Spreadsheet _spreadsheet;
  late Worksheet? _teamsheet;

  Future<void> init() async {
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _teamsheet = _spreadsheet.worksheetByTitle("teams");
  }

  Future<List<Team>> getTeamsFromApi() async {
    await init();

    final teams = await _teamsheet!.values.allRows(fromRow: 2);

    return List.generate(
      teams.length,
      (index) => Team(
        teams[index].elementAtOrNull(0) ?? "",
        teams[index].elementAtOrNull(index) ?? "",
        int.tryParse(teams[index][2]) ?? 0,
        int.tryParse(teams[index][3]) ?? 0,
        teams[index].elementAtOrNull(4) ?? "",
        teams[index].elementAtOrNull(5) ?? "",
        (teams[index].elementAtOrNull(6) ?? "")
            .split(",")
            .where((e) => e.isNotEmpty)
            .map((e) {
          final List<String> splitted = e.split(":");
          return (splitted[0], splitted[1]);
        }).toList(),
      ),
    ).reversed.toList();
  }
}
