import "package:flutter/material.dart";
import "package:fuzzywuzzy/fuzzywuzzy.dart";

class TeamSearchScreen extends StatefulWidget {
  const TeamSearchScreen({super.key});

  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearchScreen> {
  final List<String> _allItemList = [
    "raːre",
    "raːre",
    "raːre",
    "5分前行動",
    "梟",
    "5分前行動",
    "梟",
    "5分前行動",
    "raːre",
    "5分前行動",
    "梟",
    "5分前行動",
    "梟",
    "5分前行動",
    "梟",
  ];
  List<String> _displayItemList = [];

  void runFilter(String inputKeyword) {
    List<String> results = [];
    if (inputKeyword.isEmpty) {
      results = _allItemList;
    } else {
      results = extractAllSorted(
        query: inputKeyword,
        choices: _allItemList,
        cutoff: 50,
      ).map((e) => e.choice).toList();
    }
    setState(() {
      _displayItemList = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _displayItemList = _allItemList;
  }

  @override
  Widget build(BuildContext context) {
    final Size uiSize = MediaQuery.of(context).size;
    final double uiHeight = uiSize.height;
    final double uiWidth = uiSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("チーム検索"),
      ),
      body: SizedBox(
        height: uiHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: uiHeight * 0.1,
                padding: EdgeInsets.symmetric(
                  horizontal: uiWidth * 0.1,
                ),
                child: Center(
                  child: TextField(
                    onChanged: (inputKeyword) => runFilter(inputKeyword),
                    decoration: const InputDecoration(
                      labelText: "検索",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Container(
                height: uiHeight * 0.8,
                padding: EdgeInsets.only(
                  right: uiWidth * 0.1,
                  left: uiWidth * 0.1,
                ),
                child: ListView.builder(
                  itemCount: _displayItemList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(_displayItemList[index]),
                        subtitle: Text(_displayItemList[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
