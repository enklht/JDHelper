import "package:flutter/material.dart";
import "package:jdhelper/pages/team_search_screen.dart";
import "package:jdhelper/pages/trick_search_screen.dart";

class TitleScreen extends StatelessWidget {
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
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _linkButton(context, "チーム検索", const TeamSearchScreen()),
            _linkButton(context, "技検索", const TrickSearchScreen()),
          ],
        ),
      ),
    );
  }

  Widget _linkButton(
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
}
