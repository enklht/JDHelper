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
  bool _isLoading = true;
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
      _isLoading = false;
      _allItemList = fetchedList;
      _displayItemList = fetchedList;
    });
  }

  Widget _searchBar(BuildContext context, double uiWidth, double uiHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: uiWidth * 0.1,
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (inputKeyword) => runFilter(inputKeyword),
                decoration: const InputDecoration(
                  labelText: "検索",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: uiHeight * 0.4,
                      width: uiWidth,
                      child: const SingleChildScrollView(
                        child: Column(
                          children: [Text("for test")],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamList(BuildContext context, double uiWidth, double uiHeight) {
    return Expanded(
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
    );
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
            _searchBar(context, uiWidth, uiHeight),
            const Divider(),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              _teamList(context, uiWidth, uiHeight),
          ],
        ),
      ),
    );
  }
}
