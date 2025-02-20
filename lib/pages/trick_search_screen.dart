import "package:flutter/material.dart";
import "package:fuzzywuzzy/fuzzywuzzy.dart";
import "package:jdhelper/data/load_tricks.dart";
import "package:jdhelper/models/trick.dart";
import "package:jdhelper/pages/trick_detail_screen.dart";

class TrickSearchScreen extends StatefulWidget {
  const TrickSearchScreen({super.key});

  @override
  _TrickSearchState createState() => _TrickSearchState();
}

class _TrickSearchState extends State<TrickSearchScreen> {
  bool _isLoading = false;
  late List<Trick> _allItemList;
  List<Trick> _displayItemList = [];
  String _inputKeyword = "";

  late final List<String> _allProps = [
    "ボール",
    "リング",
    "クラブ",
    "シェイカーカップ",
    "シガーボックス",
    "デビルスティック",
    "ディアボロ",
    "ペアボール",
    "リングパッシング",
    "クラブパッシング",
  ];

  late List<String> _allTags = [];

  String? _selectedProp;
  late Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    final Size uiSize = MediaQuery.of(context).size;
    final double uiHeight = uiSize.height;
    final double uiWidth = uiSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("技検索"),
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

  Widget _searchBar(
    BuildContext context,
    double uiWidth,
    double uiHeight,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: uiWidth * 0.1,
      ),
      child: Column(
        children: [
          DropdownButtonFormField(
            hint: const Text("道具を選択"),
            value: _selectedProp,
            items: _allProps
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) async {
              setState(() {
                _isLoading = true;
              });
              _allItemList =
                  await TrickRepository().getTricksByProp(value.toString());
              setState(() {
                _isLoading = false;
                _selectedProp = value.toString();
                _allTags = _allItemList
                    .where((e) => e.prop == value)
                    .map((e) => e.tags)
                    .fold(<String>[], (p, e) => p..addAll(e))
                    .toSet()
                    .toList()
                  ..sort();
                _selectedTags = {};
              });
              _runFilter();
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (inputKeyword) =>
                      _runFilter(inputKeyword: inputKeyword),
                  decoration: const InputDecoration(
                    labelText: "技名で絞り込み",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _isLoading ? null : _showModal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamSubtitle(BuildContext context, Trick trick) {
    return Row(
      spacing: 10,
      children: [
        Text(
          trick.prop,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _teamList(BuildContext context, double uiWidth, double uiHeight) {
    return Expanded(
      child: ListView.builder(
        itemCount: _displayItemList.length,
        itemBuilder: (context, index) {
          final Trick trick = _displayItemList[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: uiWidth * 0.1),
            child: Card(
              child: ListTile(
                title: Text(trick.name, overflow: TextOverflow.ellipsis),
                subtitle: _teamSubtitle(context, trick),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrickDetail(trick: trick),
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

  List<Widget> _createFilter(
    String title,
    List allItems,
    Set selectedItems,
    StateSetter setState,
  ) {
    return [
      Text(title, style: const TextStyle(fontSize: 20)),
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

  void _runFilter({String? inputKeyword}) {
    final String input = inputKeyword ?? _inputKeyword;
    List<Trick> results = _allItemList
        .where(
          (e) => _selectedProp == e.prop,
        )
        .where(
          (e) =>
              _selectedTags.isEmpty ||
              _selectedTags.intersection(e.tags.toSet()).isNotEmpty,
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
      _inputKeyword = input;
      _displayItemList = results;
    });
  }

  void _showModal() {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(minWidth: double.infinity),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SafeArea(
                minimum: const EdgeInsets.all(20),
                child: Column(
                  spacing: 10,
                  children: [
                    _createFilter(
                      "タグ",
                      _allTags,
                      _selectedTags,
                      setState,
                    ),
                  ].fold([], (p, e) => p..addAll(e)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
