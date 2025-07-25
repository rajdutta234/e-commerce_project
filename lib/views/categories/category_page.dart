import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import 'package:e_commerce/routes/app_pages.dart';
import '../../views/shared/bottom_nav_bar.dart';
import 'category_card.dart';
import 'empty_state_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/category_model.dart';
import '../shared/drawer_menu.dart';
import 'dart:async';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController categoryController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RxBool searchMode = false.obs;
  Timer? _debounce;
  // Remove local state for search and sort
  // String _searchQuery = '';
  // String _sort = 'A-Z';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.setCategories([
        CategoryModel(id: '1', name: 'Electronics', image: 'https://cdn-icons-png.flaticon.com/512/1041/1041372.png'),
        CategoryModel(id: '2', name: 'Fashion', image: 'https://cdn-icons-png.flaticon.com/512/892/892458.png'),
        CategoryModel(id: '3', name: 'Home', image: 'https://cdn-icons-png.flaticon.com/512/1046/1046857.png'),
        CategoryModel(id: '4', name: 'Beauty', image: 'https://cdn-icons-png.flaticon.com/512/1046/1046875.png'),
        CategoryModel(id: '5', name: 'Sports', image: 'https://cdn-icons-png.flaticon.com/512/1046/1046861.png'),
        CategoryModel(id: '6', name: 'Toys', image: 'https://cdn-icons-png.flaticon.com/512/1046/1046871.png'),
      ]);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      categoryController.searchQuery.value = val;
    });
  }

  // Remove filteredCategories getter from widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: searchMode.value
              ? TextField(
                  key: const ValueKey('searchField'),
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                        searchMode.value = false;
                      },
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 18),
                )
              : const Text('Categories', key: ValueKey('title')),
        )),
        actions: [
          Obx(() => searchMode.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                    searchMode.value = false;
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMode.value = true;
                  },
                )),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => categoryController.sort.value = value,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'A-Z', child: Text('Sort A-Z')),
              const PopupMenuItem(value: 'Z-A', child: Text('Sort Z-A')),
            ],
          ),
        ],
      ),
      drawer: CategoryDrawerMenu(
        onCategoryTap: (categoryId) {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            categoryController.selectCategory(categoryId);
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final cats = categoryController.filteredCategories;
              if (cats.isEmpty) {
                return const EmptyStateWidget();
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : constraints.maxWidth > 600
                          ? 2
                          : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      final category = cats[index];
                      return Hero(
                        tag: 'category_${category.id}',
                        child: CategoryCard(
                          category: category,
                          subtitle: '25 items', // Example
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              categoryController.selectCategory(category.id);
                              Get.toNamed(Routes.productList, arguments: category);
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            // Already on Categories, do nothing
          } else if (index == 0) {
            Get.offAllNamed(Routes.landing);
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

class CategoryDrawerMenu extends StatelessWidget {
  final Function(String categoryId)? onCategoryTap;
  const CategoryDrawerMenu({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Center(
              child: Text('Categories', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.electrical_services),
            title: const Text('Electronics'),
            onTap: () => onCategoryTap?.call('1'),
          ),
          ListTile(
            leading: const Icon(Icons.checkroom),
            title: const Text('Fashion'),
            onTap: () => onCategoryTap?.call('2'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => onCategoryTap?.call('3'),
          ),
          ListTile(
            leading: const Icon(Icons.spa),
            title: const Text('Beauty'),
            onTap: () => onCategoryTap?.call('4'),
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Sports'),
            onTap: () => onCategoryTap?.call('5'),
          ),
          ListTile(
            leading: const Icon(Icons.toys),
            title: const Text('Toys'),
            onTap: () => onCategoryTap?.call('6'),
          ),
        ],
      ),
    );
  }
} 