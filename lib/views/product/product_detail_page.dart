import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    final CartController cartController = Get.find();
    final WishlistController wishlistController = Get.find();
    final product = productController.selectedProduct.value;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(product.image, width: 200, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('₹${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartController.addToCart(product);
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Obx(() => Icon(
                    wishlistController.isInWishlist(product.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: wishlistController.isInWishlist(product.id)
                        ? Colors.red
                        : Colors.grey,
                  )),
                  onPressed: () {
                    if (wishlistController.isInWishlist(product.id)) {
                      wishlistController.removeFromWishlist(product.id);
                    } else {
                      wishlistController.addToWishlist(product);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 