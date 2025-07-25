import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoHeader extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onEditImage;
  const ProfileInfoHeader({super.key, this.onEditProfile, this.onEditImage});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      final user = profileController.user.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover banner with gradient (no excessive top padding)
          Container(
            height: 245,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              gradient: LinearGradient(
                colors: [const Color(0xFF60A5FA), const Color(0xFFBAE6FD)], // Light blue gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Edit Profile button at top right
          Positioned(
            top: 16,
            right: 16,
            child: OutlinedButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                side: BorderSide(color: const Color.fromARGB(255, 37, 69, 231).withOpacity(0.7)),
                backgroundColor: colorScheme.primary.withOpacity(0.15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          // Avatar and user info
          Positioned(
            left: 0,
            right: 0,
            top: 40, // Move avatar and details upward
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      backgroundImage: (user?.avatar?.isNotEmpty ?? false)
                          ? NetworkImage(user!.avatar)
                          : null,
                      child: !(user?.avatar?.isNotEmpty ?? false)
                          ? Icon(Icons.person, size: 48, color: colorScheme.primary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: onEditImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(user?.name ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 4),
                Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54)),
                if (user?.address != null && user!.address.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(user.address, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black38)),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      );
    });
  }
} 