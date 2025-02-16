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

    final teams = await _teamsheet!.values.allRows();

    return List.generate(
      teams.length,
      (index) => Team(
        teams[index][0],
        teams[index][1],
        int.parse(teams[index][2]),
        int.parse(teams[index][3]),
        teams[index][4],
        teams[index][5],
        teams[index].sublist(6).map((e) {
          final List<String> splitted = e.split(':');
          return (splitted[0], splitted[1]);
        }).toList(),
      ),
    );
  }
}
