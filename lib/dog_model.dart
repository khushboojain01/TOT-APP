class Dog {
  final int? id;
  final String name;
  final String breed;
  final String? imageUrl;
  final String? breedGroup;
  final String? description;

  Dog({
    this.id,
    required this.name,
    required this.breed,
    this.imageUrl,
    this.breedGroup,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'imageUrl': imageUrl,
      'breedGroup': breedGroup,
      'description': description,
    };
  }

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      imageUrl: json['image'] ?? '',
      breedGroup: json['breed_group'] ?? '',
      description: json['description'] ?? '',
    );
  }
}