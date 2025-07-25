import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import 'package:get/get.dart';
import '../../controllers/wishlist_controller.dart';

class ProductTile extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  const ProductTile({super.key, required this.product, this.onTap, this.onAddToCart});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> with TickerProviderStateMixin {
  bool _hovering = false;
  bool _imageLoaded = false;
  late AnimationController _wishlistController;
  late AnimationController _cartController;

  @override
  void initState() {
    super.initState();
    _wishlistController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.8,
      upperBound: 1.2,
      value: 1.0,
    );
    _cartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.95,
      upperBound: 1.05,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _wishlistController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  void _animateWishlist() async {
    await _wishlistController.forward();
    await _wishlistController.reverse();
  }

  void _animateCart() async {
    await _cartController.forward();
    await _cartController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final WishlistController wishlistController = Get.find<WishlistController>();
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedBuilder(
        animation: _cartController,
        builder: (context, child) {
          return Transform.scale(
            scale: _cartController.value,
            child: child,
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          color: colorScheme.surface,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          opacity: _imageLoaded ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Image.network(
                            widget.product.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                if (!_imageLoaded) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) setState(() => _imageLoaded = true);
                                  });
                                }
                                return child;
                              }
                              return Container(
                                width: double.infinity,
                                height: 160,
                                color: colorScheme.surfaceVariant,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: 160,
                              color: colorScheme.surfaceVariant,
                              child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                            ),
                          ),
                        ),
                        if (!_imageLoaded)
                          Positioned.fill(
                            child: Container(
                              color: colorScheme.surfaceVariant,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                        // Wishlist icon button (top right)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Obx(() {
                            final isWishlisted = wishlistController.isInWishlist(widget.product.id);
                            return ScaleTransition(
                              scale: _wishlistController,
                              child: Material(
                                color: Colors.white.withOpacity(0.85),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    _animateWishlist();
                                    if (isWishlisted) {
                                      wishlistController.removeFromWishlist(widget.product.id);
                                    } else {
                                      wishlistController.addToWishlist(widget.product);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                                      color: isWishlisted ? Colors.red : Colors.grey,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.product.name,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '₹${widget.product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(color: colorScheme.primary, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(widget.product.rating.toString(), style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _animateCart();
                            if (widget.onAddToCart != null) widget.onAddToCart!();
                          },
                          icon: const Icon(Icons.add_shopping_cart, size: 22),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 