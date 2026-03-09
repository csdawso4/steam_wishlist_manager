class Game {
  Game({
    required this.gid,
    required this.name,
    required this.shortdesc,
    required this.capsuleimgurl,
    required this.currentprice,
    required this.currentpercent,
    required this.bestrecordedprice,
    required this.bestrecordedpercent,
  });

  int gid;
  String name;
  String shortdesc;
  String capsuleimgurl;
  int currentprice;
  int currentpercent;
  int bestrecordedprice;
  int bestrecordedpercent;
}
