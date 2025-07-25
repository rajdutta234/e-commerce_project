import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'profile_info_header.dart';
import 'profile_action_tile.dart';
import 'settings_list_section.dart';
import 'logout_button.dart';
import 'package:e_commerce/routes/app_pages.dart';
import '../../views/shared/bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    void showComingSoon(String feature) {
      Get.snackbar(
        'Coming Soon',
        '$feature will be available in a future update.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileInfoHeader(
                onEditProfile: () => Get.toNamed('/edit_profile'),
                onEditImage: () async {
                  final result = await Get.toNamed('/edit_profile', arguments: {'openImagePicker': true});
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Quick Actions', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    ProfileActionTile(
                      icon: Icons.receipt_long,
                      label: 'Orders',
                      onTap: () => Get.toNamed(Routes.orders),
                    ),
                    ProfileActionTile(
                      icon: Icons.favorite,
                      label: 'Wishlist',
                      onTap: () => Get.toNamed(Routes.wishlist),
                    ),
                    ProfileActionTile(
                      icon: Icons.shopping_cart,
                      label: 'Cart',
                      onTap: () => Get.toNamed(Routes.cart),
                    ),
                    ProfileActionTile(
                      icon: Icons.location_on,
                      label: 'Address Book',
                      onTap: () => Get.toNamed('/address_book'),
                    ),
                    ProfileActionTile(
                      icon: Icons.card_giftcard,
                      label: 'My Coupons',
                      onTap: () => showComingSoon('My Coupons'),
                    ),
                    ProfileActionTile(
                      icon: Icons.credit_card,
                      label: 'Saved Cards',
                      onTap: () => showComingSoon('Saved Cards'),
                    ),
                    ProfileActionTile(
                      icon: Icons.history,
                      label: 'Recently Viewed',
                      onTap: () => showComingSoon('Recently Viewed'),
                    ),
                    ProfileActionTile(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () => showComingSoon('Settings'),
                    ),
                    ProfileActionTile(
                      icon: Icons.help_outline,
                      label: 'Help Center',
                      onTap: () => showComingSoon('Help Center'),
                    ),
                    ProfileActionTile(
                      icon: Icons.qr_code,
                      label: 'Invite a Friend',
                      onTap: () => showComingSoon('Invite a Friend'),
                    ),
                    ProfileActionTile(
                      icon: Icons.dark_mode,
                      label: 'Theme',
                      onTap: () => showComingSoon('Theme Toggle'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => SettingsListSection(
                notificationsEnabled: profileController.notificationsEnabled.value,
                onToggleNotifications: (val) => profileController.toggleNotifications(val),
                onChangePassword: () => showComingSoon('Change Password'),
                onLanguage: () => showComingSoon('Language Selection'),
                onTerms: () => showComingSoon('Terms & Conditions'),
                onPrivacy: () => showComingSoon('Privacy Policy'),
              )),
              const SizedBox(height: 16),
              LogoutButton(
                onLogout: () {
                  // Add your logout logic here
                  Get.offAllNamed(Routes.landing);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) {
            // Already on Profile, do nothing
          } else if (index == 0) {
            Get.offAllNamed(Routes.landing);
          } else if (index == 1) {
            Get.toNamed(Routes.categories);
          } else if (index == 2) {
            Get.toNamed(Routes.cart);
          }
        },
      ),
    );
  }
} 