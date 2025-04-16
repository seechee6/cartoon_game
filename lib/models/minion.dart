class Minion {
  final String id;
  final String name;
  final String image;
  final String description;
  final List<String> funFacts;
  final String favoriteActivity;
  final String color;
  final String? soundFile;

  Minion({
    required this.id,
    required this.name, 
    required this.image,
    required this.description,
    required this.funFacts,
    required this.favoriteActivity,
    required this.color,
    this.soundFile,
  });
} 