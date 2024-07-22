class Juice {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final JuiceCategory category;
  List<Version>availableVersions;

  Juice({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableVersions,
  });
}

enum JuiceCategory {
  Citricos,
  Vermelhos,
  Verdes,
  Tropicais,
  Detox,
}

class Version {
  String name;
  double price;

  Version({
    required this.name,
    required this.price,
  });
}