import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../services/product_service.dart';
import '../shared/custom_app_bar.dart';
import '../shared/drawer_menu.dart';
import '../shared/bottom_nav_bar.dart';
import '../shared/product_tile.dart';
import 'package:e_commerce/routes/app_pages.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/profile_controller.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.find<CartController>();
  final WishlistController wishlistController = Get.put(WishlistController());
  final ProductController productController = Get.put(ProductController());
  final ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _suggestionsOverlay;
  String _searchText = '';
  List<String> _recentSearches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set dummy banner and featured products
    homeController.setBannerImage('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80');
    homeController.setFeaturedProducts(ProductService().getFeaturedProducts());
    productController.setProducts(ProductService().getProducts());
    _searchFocusNode.addListener(_handleFocusChange);
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
      productController.setSearchQuery(_searchController.text);
      if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty && _recentSearches.isNotEmpty) {
        _showSuggestionsOverlay();
      } else {
        _removeSuggestionsOverlay();
      }
    });
  }

  void _handleFocusChange() {
    if (_searchFocusNode.hasFocus && _searchText.isNotEmpty && _recentSearches.isNotEmpty) {
      _showSuggestionsOverlay();
    } else {
      _removeSuggestionsOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    _removeSuggestionsOverlay();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _suggestionsOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56), // AppBar height
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: _recentSearches
                    .where((s) => s.toLowerCase().contains(_searchText.toLowerCase()))
                    .map((s) => ListTile(
                          title: Text(s),
                          leading: const Icon(Icons.history, size: 18),
                          onTap: () {
                            _onSearch(s);
                            _removeSuggestionsOverlay();
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_suggestionsOverlay!);
  }

  void _removeSuggestionsOverlay() {
    _suggestionsOverlay?.remove();
    _suggestionsOverlay = null;
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty && !_recentSearches.contains(query.trim())) {
      setState(() {
        _recentSearches.insert(0, query.trim());
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      });
    }
    _removeSuggestionsOverlay();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _removeSuggestionsOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onWishlistTap() {
    Get.toNamed(Routes.wishlist);
  }

  void _onNavigateDrawer(String route) {
    Get.toNamed(route);
  }

  void _onProductTap(product) {
    Get.toNamed(Routes.productDetail, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Material(
            elevation: 4,
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8, top: 2, bottom: 0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.menu, size: 28),
                          onPressed: _onMenuTap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() {
                          final user = profileController.user.value;
                          return Text(
                            user?.name ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, size: 26),
                        onPressed: () {
                          Get.toNamed('/search');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: DrawerMenu(onNavigate: _onNavigateDrawer),
      body: Obx(() {
        final query = productController.searchQuery.value.trim();
        final allProducts = productController.products;
        final filtered = query.isEmpty
            ? homeController.featuredProducts
            : allProducts.where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase())
              ).toList();
        if (query.isEmpty) {
          // Show normal landing page
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => homeController.bannerImage.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        height: 400,
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: NetworkImage(homeController.bannerImage.value),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Gradient overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Welcome text
                            Positioned(
                              left: 24,
                              bottom: 32,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Welcome to\n',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'E-Commerce!',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                  child: Text('Featured Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        itemCount: homeController.featuredProducts.length,
                        itemBuilder: (context, index) {
                          final product = homeController.featuredProducts[index];
                          return ProductTile(
                            product: product,
                            onTap: () => _onProductTap(product),
                            onAddToCart: () {
                              cartController.addToCart(product);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        } else {
          // Show only search results
          return filtered.isEmpty
              ? const Center(child: Text('No products found'))
              : Padding(
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
                            onTap: () => _onProductTap(product),
                            onAddToCart: () {
                              cartController.addToCart(product);
                            },
                          );
                        },
                      );
                    },
                  ),
                );
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on Home, do nothing
          } else if (index == 1) {
            Get.toNamed(Routes.categories);
          } else if (index == 2) {
            Get.toNamed(Routes.cart);
          } else if (index == 3) {
            Get.toNamed(Routes.profile);
          }
        },
        animateCart: cartController.animateCart.value,
      )),
    );
  }
} 