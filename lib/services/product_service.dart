import '../models/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Modern Chair',
      description: 'A stylish modern chair.',
      image: 'https://via.placeholder.com/150',
      price: 120.0,
      category: 'furniture',
      isFeatured: true,
      rating: 4.5,
    ),
    ProductModel(
      id: '2',
      name: 'Wireless Headphones',
      description: 'High quality wireless headphones.',
      image: 'https://via.placeholder.com/150',
      price: 80.0,
      category: 'electronics',
      isFeatured: true,
      rating: 4.7,
    ),
    // Add more dummy products
  ];

  List<ProductModel> getProducts() => _products;

  List<ProductModel> getFeaturedProducts() =>
      _products.where((p) => p.isFeatured).toList();

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
} 