import 'package:gsheets/gsheets.dart';
import 'package:street_performance_helper/env/env.dart';
import 'package:street_performance_helper/models/team.dart';

final String _cresidentials = Env.cresidential;
final String _spreadsheetId = Env.spreadsheetId;

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
      (index) {
        final team = teams[index];
        return Team(
          team.elementAtOrNull(0) ?? "",
          team.elementAtOrNull(1) ?? "",
          int.tryParse(team.elementAtOrNull(2) ?? ""),
          int.tryParse(team.elementAtOrNull(3) ?? ""),
          team.elementAtOrNull(4),
          team.elementAtOrNull(5),
          team
              .elementAtOrNull(6)
              ?.split(",")
              .where((e) => e.isNotEmpty)
              .map((e) {
            final List<String> splitted = e.split(":");
            return (splitted[0], splitted[1]);
          }).toList(),
          team.elementAtOrNull(7),
          team.elementAtOrNull(8),
          team.elementAtOrNull(9),
        );
      },
    );
  }
}
