import "package:flutter/material.dart";
import "package:fuzzywuzzy/fuzzywuzzy.dart";
import "package:street_performance_helper/data/load_teams.dart";
import "package:street_performance_helper/models/team.dart";
import "package:street_performance_helper/pages/team_detail_screen.dart";

class TeamSearchScreen extends StatefulWidget {
  const TeamSearchScreen({super.key});

  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearchScreen> {
  bool isLoading = true;
  late List<Team> _allItemList;
  late List<Team> _displayItemList;

  void runFilter(String inputKeyword) {
    List<Team> results = [];
    if (inputKeyword.isEmpty) {
      results = _allItemList;
    } else {
      results = extractAllSorted(
        query: inputKeyword,
        choices: _allItemList,
        cutoff: 50,
        getter: (e) => e.name,
      ).map((e) => e.choice).toList();
    }
    setState(() {
      _displayItemList = results;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final List<Team> fetchedList = await TeamRepository().getTeamsFromApi();
    setState(() {
      isLoading = false;
      _allItemList = fetchedList;
      _displayItemList = fetchedList;
    });
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
            if (isLoading)
              Container(
                padding: const EdgeInsets.all(10),
                width: 100,
                height: 100,
                child: const CircularProgressIndicator(),
              )
            else
              SizedBox(
                height: uiHeight * 0.8,
                child: ListView.builder(
                  itemCount: _displayItemList.length,
                  itemBuilder: (context, index) {
                    final Team team = _displayItemList[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: uiWidth * 0.1),
                      child: Card(
                        child: ListTile(
                          title: Text(team.name),
                          subtitle: Text(team.year.toString()),
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TeamDetail(team: team),
                              ),
                            ),
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
