import '../models/product_model.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<ProductModel> _wishlist = [];

  List<ProductModel> getWishlist() => _wishlist;

  void addToWishlist(ProductModel product) {
    if (!_wishlist.any((item) => item.id == product.id)) {
      _wishlist.add(product);
    }
  }

  void removeFromWishlist(String productId) {
    _wishlist.removeWhere((item) => item.id == productId);
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }
} 