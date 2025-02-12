import 'dart:convert';
import 'package:flutter/material.dart';
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
        throw 'Failed to Load Data.';
      }

      final Map<String, dynamic> message =
          jsonDecode(res.body) as Map<String, dynamic>;
      if (message['values'] == null) {
        throw 'Failed to fetch database.';
      }

      final List values = message['values'] as List;
      for (final value in values) {
        final valueList = List<String>.from(value as List);
        result.add(
          Team(
            valueList[0],
            valueList[1],
            int.parse(valueList[2]),
            int.parse(valueList[3]),
            valueList[4],
            valueList[5],
            valueList.sublist(6).map((e) {
              final List<String> splitted = e.split(':');
              return (splitted[0], splitted[1]);
            }).toList(),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString()); // エラーはログに出力して握りつぶす
    }
    return result;
  }
}
