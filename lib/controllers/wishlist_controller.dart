import 'package:get/get.dart';
import '../models/product_model.dart';

class WishlistController extends GetxController {
  var wishlist = <ProductModel>[].obs;

  void addToWishlist(ProductModel product) {
    if (!wishlist.any((item) => item.id == product.id)) {
      wishlist.add(product);
    }
  }

  void removeFromWishlist(String productId) {
    wishlist.removeWhere((item) => item.id == productId);
  }

  bool isInWishlist(String productId) {
    return wishlist.any((item) => item.id == productId);
  }
} 