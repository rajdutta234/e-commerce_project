import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class SettingsListSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool>? onToggleNotifications;
  final VoidCallback? onChangePassword;
  final VoidCallback? onLanguage;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;
  const SettingsListSection({
    super.key,
    this.notificationsEnabled = true,
    this.onToggleNotifications,
    this.onChangePassword,
    this.onLanguage,
    this.onTerms,
    this.onPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ProfileController profileController = Get.find<ProfileController>();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          if (profileController.recentSearches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: profileController.clearRecentSearches,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: Obx(() => ListView(
                children: profileController.recentSearches
                    .map((s) => ListTile(
                          leading: const Icon(Icons.history, size: 20),
                          title: Text(s),
                        ))
                    .toList(),
              )),
            ),
            const Divider(indent: 16, endIndent: 16),
          ],
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Language', style: GoogleFonts.poppins()),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLanguage,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: Text('Notifications', style: GoogleFonts.poppins()),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: onToggleNotifications,
              activeColor: colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text('Change Password', style: GoogleFonts.poppins()),
            trailing: const Icon(Icons.chevron_right),
            onTap: onChangePassword,
          ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('App Version', style: GoogleFonts.poppins()),
            trailing: Text('1.0.0', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text('Terms & Conditions', style: GoogleFonts.poppins()),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTerms,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy', style: GoogleFonts.poppins()),
            trailing: const Icon(Icons.chevron_right),
            onTap: onPrivacy,
          ),
        ],
      ),
    );
  }
} 