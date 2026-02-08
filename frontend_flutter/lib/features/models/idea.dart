class Idea {
  final String id;
  final String text;
  final int vote;

  Idea({required this.id, required this.text, required this.vote});

  //factory get from json (go)
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      vote: json['vote'] ?? '',
    );
  }
}
