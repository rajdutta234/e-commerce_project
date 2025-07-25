import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../views/shared/product_tile.dart';
import '../views/shared/bottom_nav_bar.dart';
import 'package:e_commerce/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductController productController = Get.isRegistered<ProductController>()
      ? Get.find<ProductController>()
      : Get.put(ProductController());
  final TextEditingController _searchController = TextEditingController();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      productController.setSearchQuery(_searchController.text);
    });
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    profileController.addRecentSearch(query);
    productController.setSearchQuery(query);
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(TextPosition(offset: query.length));
  }

  @override
  void dispose() {
    _searchController.dispose();
    productController.setSearchQuery('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
          onSubmitted: _onSearch,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final query = productController.searchQuery.value.trim();
        final allProducts = productController.products;
        final filtered = query.isEmpty
            ? <dynamic>[]
            : allProducts.where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase())
              ).toList();
        if (query.isEmpty) {
          return const Center(child: Text('Type to search for products.'));
        } else if (filtered.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 900
                    ? 4
                    : constraints.maxWidth > 600
                        ? 3
                        : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ProductTile(
                      product: product,
                      onTap: () {},
                      onAddToCart: () {},
                    );
                  },
                );
              },
            ),
          );
        }
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed(Routes.landing);
          } else if (index == 1) {
            Get.toNamed(Routes.categories);
          } else if (index == 2) {
            Get.toNamed(Routes.cart);
          } else if (index == 3) {
            Get.toNamed(Routes.profile);
          }
        },
      ),
    );
  }
} 