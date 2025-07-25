class ProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String category;
  final bool isFeatured;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.isFeatured,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        price: (json['price'] as num).toDouble(),
        category: json['category'],
        isFeatured: json['isFeatured'] ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'price': price,
        'category': category,
        'isFeatured': isFeatured,
        'rating': rating,
      };
} 