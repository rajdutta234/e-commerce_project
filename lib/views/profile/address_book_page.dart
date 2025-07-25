import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressBookPage extends StatelessWidget {
  const AddressBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Address Book')),
      body: Obx(() {
        final addresses = profileController.addresses;
        final selected = profileController.selectedAddressIndex.value;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Addresses', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16),
              Expanded(
                child: addresses.isEmpty
                    ? Center(child: Text('No addresses found. Add a new address.', style: GoogleFonts.poppins()))
                    : ListView.separated(
                        itemCount: addresses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: selected == i ? colorScheme.primary.withOpacity(0.08) : null,
                          child: ListTile(
                            leading: Icon(
                              selected == i ? Icons.check_circle : Icons.location_on,
                              color: selected == i ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            ),
                            title: Text(addresses[i], style: GoogleFonts.poppins()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit',
                                  onPressed: () async {
                                    final newAddress = await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        final controller = TextEditingController(text: addresses[i]);
                                        return AlertDialog(
                                          title: const Text('Edit Address'),
                                          content: TextField(
                                            controller: controller,
                                            decoration: const InputDecoration(hintText: 'Enter address'),
                                            autofocus: true,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context, controller.text.trim()),
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (newAddress != null && newAddress.isNotEmpty) {
                                      profileController.editAddress(i, newAddress);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Delete Address',
                                      middleText: 'Are you sure you want to delete this address?',
                                      textCancel: 'Cancel',
                                      textConfirm: 'Delete',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        profileController.deleteAddress(i);
                                        Get.back();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () => profileController.selectAddress(i),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Add New Address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  onPressed: () async {
                    final newAddress = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('Add New Address'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(hintText: 'Enter new address'),
                            autofocus: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, controller.text.trim()),
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                    if (newAddress != null && newAddress.isNotEmpty) {
                      profileController.addAddress(newAddress);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
} 