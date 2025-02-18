import 'package:gsheets/gsheets.dart';
import 'package:street_performance_helper/env/env.dart';
import 'package:street_performance_helper/models/trick.dart';

final String _cresidentials = Env.cresidential;
final String _spreadsheetId = Env.spreadsheetId;

class TrickRepository {
  final _gsheets = GSheets(_cresidentials);
  late Spreadsheet _spreadsheet;
  late Worksheet? _teamsheet;

  Future<void> init() async {
    _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _teamsheet = _spreadsheet.worksheetByTitle("tricks");
  }

  Future<List<Trick>> getTeamsFromApi() async {
    await init();

    final tricks = await _teamsheet!.values.allRows(fromRow: 2);

    return List.generate(
      tricks.length,
      (index) {
        final trick = tricks[index];
        return Trick(
          trick.elementAtOrNull(0) ?? "",
          trick.elementAtOrNull(1) ?? "",
          trick
                  .elementAtOrNull(2)
                  ?.split(",")
                  .where((e) => e.isNotEmpty)
                  .toList() ??
              [],
          trick
                  .elementAtOrNull(3)
                  ?.split(",")
                  .where((e) => e.isNotEmpty)
                  .map((e) {
                final List<String> splitted = e.split(":");
                return (splitted[0], splitted[1]);
              }).toList() ??
              [],
        );
      },
    );
  }
}
