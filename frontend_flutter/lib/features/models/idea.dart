class Idea {
  final String id;
  final String text;
  final int vote;

  Idea({required this.id, required this.text, required this.vote});

  //factory get from json (go)
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id']?.toString() ?? '',
      text: json['text'].toString(),
      vote: json['votes'] is int
          ? json['votes']
          : int.tryParse(json['votes']?.toString() ?? '0') ?? 0,
    );
  }
}
