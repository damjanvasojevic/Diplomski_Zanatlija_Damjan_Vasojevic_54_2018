enum CraftCategory {
  vodoinstalater,
  elektricar,
  bravar,
  varioc,
  mehanicar,
}

class Craft {
  final String id;
  final String userId;
  final String craftsmanName;
  final String craftName;
  final String location;
  final int price;
  final String description;
  String? imageUrl;
  final double? rate;

  Craft({
    required this.userId,
    required this.id,
    required this.craftsmanName,
    required this.craftName,
    required this.description,
    this.imageUrl,
    this.rate,
    required this.location,
    required this.price,
  });

  factory Craft.fromJson(Map<String, dynamic> json) => Craft(
        id: json['id'],
        userId: json['userId'],
        craftsmanName: json['craftsmanName'],
        craftName: json['craftName'],
        location: json['location'],
        price: json['price'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        rate: json['rate'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'craftsmanName': craftsmanName,
        'craftName': craftName,
        'location': location,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'rate': rate,
      };
}
