import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/category_model.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final String? subtitle;
  const CategoryCard({super.key, required this.category, this.onTap, this.subtitle});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.08),
              colorScheme.secondary.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovering ? colorScheme.primary.withOpacity(0.18) : Colors.black12,
              blurRadius: _hovering ? 16 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.white,
                      width: 56,
                      height: 56,
                      child: widget.category.image.isNotEmpty
                          ? Image.network(widget.category.image, fit: BoxFit.cover, width: 56, height: 56, errorBuilder: (c, e, s) => const Icon(Icons.category, size: 32, color: Colors.grey))
                          : const Icon(Icons.category, size: 32, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(widget.category.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(widget.subtitle!,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 