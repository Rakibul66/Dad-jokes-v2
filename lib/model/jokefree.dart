class JokeFreeModel {
  final String setup;
  final String punchline;

  JokeFreeModel({required this.setup, required this.punchline});

  factory JokeFreeModel.fromJson(Map<String, dynamic> json) {
    return JokeFreeModel(
      setup: json['setup'],
      punchline: json['punchline'],
    );
  }
}
