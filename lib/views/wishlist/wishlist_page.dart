import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wishlist_controller.dart';
import 'package:e_commerce/routes/app_pages.dart';
import '../../views/shared/bottom_nav_bar.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.find();
    int _currentIndex = 2;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Wishlist'),
          ),
          body: Obx(() {
            if (wishlistController.wishlist.isEmpty) {
              return const Center(child: Text('No items in wishlist'));
            }
            return ListView.builder(
              itemCount: wishlistController.wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlistController.wishlist[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(product.image, width: 56, height: 56, fit: BoxFit.cover),
                    title: Text(product.name),
                    subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        wishlistController.removeFromWishlist(product.id);
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  Get.toNamed(Routes.landing);
                  break;
                case 1:
                  Get.toNamed(Routes.categories);
                  break;
                case 2:
                  Get.toNamed(Routes.cart);
                  break;
                case 3:
                  Get.toNamed(Routes.profile);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
} 