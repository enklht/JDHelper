import "package:flutter/material.dart";
import "package:street_performance_helper/pages/team_search_screen.dart";

class TitleScreen extends StatelessWidget {
  Widget _createLinkButton(
    BuildContext context,
    String data,
    Widget destination,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
      child: SizedBox(
        width: 200,
        height: 50,
        child: Center(
          child: Text(
            data,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("大道芸検索アプリ（仮）"),
        leading: Icon(
          Icons.donut_large,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createLinkButton(context, "チーム検索", const TeamSearchScreen()),
            const SizedBox(height: 20),
            _createLinkButton(context, "技検索", const TeamSearchScreen()),
          ],
        ),
      ),
    );
  }
}
