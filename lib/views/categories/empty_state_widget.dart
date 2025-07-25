import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('No categories found',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black54)),
            const SizedBox(height: 8),
            Text('Try a different search or filter.',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black38)),
          ],
        ),
      ),
    );
  }
} 