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
  late final List<Team> _allItemList;
  late List<Team> _displayItemList;
  String _inputKeyword = "";

  late final List<int> _allYears;
  late final List<int> _allMemberNums;
  late final List<String> _allKinds;

  late Set<int> _selectedYears;
  late Set<int> _selectedMemberNums;
  late Set<String> _selectedKinds;

  @override
  void initState() {
    super.initState();
    _fetchData();
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
      body: Column(
        children: [
          _searchBar(context, uiWidth, uiHeight),
          const Divider(),
          if (_isLoading)
            const Column(
              children: [
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            )
          else
            _teamList(context, uiWidth, uiHeight),
        ],
      ),
    );
  }

  void _runFilter({String inputKeyword = ""}) {
    final String input = inputKeyword.isEmpty ? _inputKeyword : inputKeyword;
    List<Team> results = _allItemList
        .where(
          (e) => _selectedYears.isEmpty || _selectedYears.contains(e.year),
        )
        .where(
          (e) =>
              _selectedMemberNums.isEmpty ||
              _selectedMemberNums.contains(e.memberNum),
        )
        .where(
          (e) => _selectedKinds.isEmpty || _selectedKinds.contains(e.kind),
        )
        .toList();
    if (input.isNotEmpty) {
      results = extractAllSorted(
        query: input,
        choices: results,
        cutoff: 50,
        getter: (e) => e.name,
      ).map((e) => e.choice).toList();
    }
    setState(() {
      _inputKeyword = inputKeyword;
      _displayItemList = results;
    });
  }

  Future<void> _fetchData() async {
    final List<Team> fetchedList = await TeamRepository().getTeamsFromApi();
    setState(() {
      _isLoading = false;
      _allItemList = fetchedList;
      _displayItemList = fetchedList;

      _selectedMemberNums = {};
      _selectedYears = {};
      _selectedKinds = {};

      _allYears = _allItemList.map((e) => e.year).toSet().toList();
      _allYears.sort();

      _allMemberNums = _allItemList.map((e) => e.memberNum).toSet().toList();
      _allMemberNums.sort();

      _allKinds = _allItemList.map((e) => e.kind).toSet().toList();
    });
  }

  List<Widget> _createFilter(
    String title,
    List allItems,
    Set selectedItems,
    StateSetter setState,
  ) {
    return [
      const SizedBox(height: 10),
      Text(title, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: allItems
              .map(
                (e) => FilterChip(
                  showCheckmark: false,
                  label: Text(e.toString()),
                  selected: selectedItems.contains(e),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedItems.add(e);
                      } else {
                        selectedItems.remove(e);
                      }
                    });
                    _runFilter();
                  },
                ),
              )
              .toList(),
        ),
      ),
    ];
  }

  Widget _searchBar(BuildContext context, double uiWidth, double uiHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: uiWidth * 0.1,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (inputKeyword) =>
                  _runFilter(inputKeyword: inputKeyword),
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
                constraints: const BoxConstraints.expand(),
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _createFilter(
                              "年度",
                              _allYears,
                              _selectedYears,
                              setState,
                            ),
                            _createFilter(
                              "人数",
                              _allMemberNums,
                              _selectedMemberNums,
                              setState,
                            ),
                            _createFilter(
                              "種類",
                              _allKinds,
                              _selectedKinds,
                              setState,
                            ),
                          ].fold([], (p, e) => p..addAll(e)),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
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
                title: Text(team.name, overflow: TextOverflow.ellipsis),
                subtitle:
                    Text(team.year.toString(), overflow: TextOverflow.ellipsis),
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
}
