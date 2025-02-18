class Team {
  String name;
  String pronounciation;
  int? year;
  int? memberNum;
  String? kind;
  String? youtubeId;
  List<(String, String)>? program;
  String? theme;
  String? characters;
  String? note;

  Team(
    this.name,
    this.pronounciation,
    this.year,
    this.memberNum,
    this.kind,
    this.youtubeId,
    this.program,
    this.theme,
    this.characters,
    this.note,
  );
}
