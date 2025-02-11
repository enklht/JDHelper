import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;
import 'package:street_performance_helper/models/team.dart';

class TeamRepository {
  static const String spreadsSheetsUrl =
      "1Vapku8W_-b3qfeAMK9l3uKoQw9feuebLHXSVFQdZJZQ";
  static const String sheetName = "teams";
  static const String apiKey = "AIzaSyBvxzB-UqLV7oWAURpwOa3fWwgDyf-J00c";

  Future<List<Team>> getTeamsFromApi() async {
    final List<Team> result = [];
    try {
      final url = Uri.parse(
        "https://sheets.googleapis.com/v4/spreadsheets/$spreadsSheetsUrl/values/$sheetName?key=$apiKey",
      );

      final res = await http.get(url);
      if (res.statusCode != 200) {
        throw 'Failed to Load English Word Data.';
      }

      final Map<String, dynamic> message =
          jsonDecode(res.body) as Map<String, dynamic>;
      if (message['values'] == null) {
        throw 'Failed to fetch database.';
      }

      final values = message['values'];
      for (final value in values as List) {
        final valueList = List<String>.from(value);
        result.add(
          Team(
            valueList[0],
            int.parse(valueList[1]),
            int.parse(valueList[2]),
            valueList[3],
            [],
          ),
        );
      }
    } catch (e) {
      print(e); // エラーはログに出力して握りつぶす
    }
    return result;
  }
}
