import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../themes/app_theme.dart';

class DrawerMenu extends StatelessWidget {
  final Function(String route)? onNavigate;
  const DrawerMenu({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text('E-Commerce App', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: 8),
          _DrawerMenuItem(
            icon: Icons.home,
            label: 'Home',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/'),
          ),
          _DrawerMenuItem(
            icon: Icons.person,
            label: 'Profile',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/profile'),
          ),
          _DrawerMenuItem(
            icon: Icons.receipt_long,
            label: 'My Orders',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/orders'),
          ),
          _DrawerMenuItem(
            icon: Icons.category,
            label: 'Categories',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/categories'),
          ),
          _DrawerMenuItem(
            icon: Icons.favorite,
            label: 'Wishlist',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/wishlist'),
          ),
          _DrawerMenuItem(
            icon: Icons.settings,
            label: 'Settings',
            color: colorScheme.primary,
            onTap: () => onNavigate?.call('/settings'),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _DrawerMenuItem({required this.icon, required this.label, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      onTap: onTap,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      minLeadingWidth: 32,
    );
  }
} 