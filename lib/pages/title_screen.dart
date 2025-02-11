import "package:flutter/material.dart";
import "package:street_performance_helper/pages/team_search_screen.dart";

class TitleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("大道芸検索アプリ（仮）"),
        leading: Icon(
          Icons.donut_large_rounded,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamSearchScreen(),
              ),
            );
          },
          child: const Text("チーム検索"),
        ),
      ),
    );
  }
}
