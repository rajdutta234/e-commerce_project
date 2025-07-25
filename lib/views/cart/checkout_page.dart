import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final profileController = Get.find<ProfileController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Obx(() {
        final user = profileController.user.value;
        if (user == null) {
          return const Center(child: Text('No user data. Please log in.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Order Summary
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cartController.cartItems.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 48,
                            height: 48,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                      title: Text(item.product.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      subtitle: Text('x${item.quantity}', style: GoogleFonts.poppins(fontSize: 13)),
                      trailing: Text('₹${item.totalPrice.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Address Section
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on),
                        title: Text('Delivery Address', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.address.isNotEmpty ? user.address : 'Add address', style: GoogleFonts.poppins(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Get.toNamed('/delivery_address');
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          child: TextButton.icon(
                            icon: const Icon(Icons.add_location_alt),
                            label: const Text('Add New Address'),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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
                                profileController.updateUser(
                                  user.copyWith(address: newAddress),
                                );
                                Get.snackbar('Address Added', 'Your new address has been saved.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Payment Method Section
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Payment Method', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Obx(() => Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _PaymentOption(
                            icon: Icons.credit_card,
                            label: 'Card',
                            selected: cartController.selectedPaymentMethod.value == 'Card',
                            onTap: () => cartController.selectPaymentMethod('Card'),
                          ),
                          _PaymentOption(
                            icon: Icons.account_balance_wallet,
                            label: 'Wallet',
                            selected: cartController.selectedPaymentMethod.value == 'Wallet',
                            onTap: () => cartController.selectPaymentMethod('Wallet'),
                          ),
                          _PaymentOption(
                            icon: Icons.account_balance,
                            label: 'NetBanking',
                            selected: cartController.selectedPaymentMethod.value == 'NetBanking',
                            onTap: () => cartController.selectPaymentMethod('NetBanking'),
                          ),
                          _PaymentOption(
                            icon: Icons.qr_code,
                            label: 'UPI',
                            selected: cartController.selectedPaymentMethod.value == 'UPI',
                            onTap: () => cartController.selectPaymentMethod('UPI'),
                          ),
                          _PaymentOption(
                            icon: Icons.money,
                            label: 'COD',
                            selected: cartController.selectedPaymentMethod.value == 'COD',
                            onTap: () => cartController.selectPaymentMethod('COD'),
                          ),
                        ],
                      )),
                      const SizedBox(height: 16),
                      Obx(() {
                        switch (cartController.selectedPaymentMethod.value) {
                          case 'Card':
                            return _CardPaymentForm(cartController: cartController);
                          case 'UPI':
                            return _UPIPaymentForm(cartController: cartController);
                          case 'NetBanking':
                            return _NetBankingForm(cartController: cartController);
                          case 'Wallet':
                            return _WalletForm(cartController: cartController);
                          default:
                            return const SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Coupon Section
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.card_giftcard),
                    title: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter coupon code',
                        border: InputBorder.none,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {/* Apply coupon */},
                      child: const Text('Apply'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Order Total & Place Order
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Subtotal'), Text('₹${cartController.total.value.toStringAsFixed(2)}'),
                      ]),
                      // Add shipping, discount, etc.
                      const Divider(),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        Text('₹${cartController.total.value.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Payment:', style: GoogleFonts.poppins()),
                        Obx(() => Text(cartController.selectedPaymentMethod.value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => _PlaceOrderButton(
                enabled: cartController.validatePayment(),
                onOrderPlaced: () {
                  // You can add navigation or snackbar here
                  Get.snackbar('Order Placed', 'Your order has been placed successfully!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
              )),
            ],
          ),
        );
      }),
    );
  }
}

// Add payment option and form widgets at the end of the file
class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentOption({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(icon, size: 20),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}

class _CardPaymentForm extends StatelessWidget {
  final CartController cartController;
  const _CardPaymentForm({required this.cartController});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        return Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Card Number', prefixIcon: Icon(Icons.credit_card)),
              keyboardType: TextInputType.number,
              maxLength: 16,
              onChanged: (v) => cartController.cardNumber.value = v,
            ),
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                          keyboardType: TextInputType.datetime,
                          onChanged: (v) => cartController.cardExpiry.value = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 02), // Slightly lower CVV
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'CVV'),
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            onChanged: (v) => cartController.cardCvv.value = v,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                        keyboardType: TextInputType.datetime,
                        onChanged: (v) => cartController.cardExpiry.value = v,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12), // Slightly lower CVV
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'CVV'),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          onChanged: (v) => cartController.cardCvv.value = v,
                        ),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}

class _UPIPaymentForm extends StatelessWidget {
  final CartController cartController;
  const _UPIPaymentForm({required this.cartController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'UPI ID', prefixIcon: Icon(Icons.qr_code)),
      onChanged: (v) => cartController.upiId.value = v,
    );
  }
}

class _NetBankingForm extends StatelessWidget {
  final CartController cartController;
  const _NetBankingForm({required this.cartController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Bank Name', prefixIcon: Icon(Icons.account_balance)),
      onChanged: (v) => cartController.netBankingBank.value = v,
    );
  }
}

class _WalletForm extends StatelessWidget {
  final CartController cartController;
  const _WalletForm({required this.cartController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Wallet Type (e.g. Paytm, PhonePe)', prefixIcon: Icon(Icons.account_balance_wallet)),
      onChanged: (v) => cartController.walletType.value = v,
    );
  }
}

class _PlaceOrderButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onOrderPlaced;
  const _PlaceOrderButton({required this.enabled, required this.onOrderPlaced});
  @override
  State<_PlaceOrderButton> createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<_PlaceOrderButton> with TickerProviderStateMixin {
  bool _loading = false;
  bool _success = false;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    setState(() => _success = true);
    _successController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _success = false);
    _successController.reset();
    widget.onOrderPlaced();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.enabled && !_loading && !_success ? _placeOrder : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _loading
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                )
              : _success
                  ? ScaleTransition(
                      scale: CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
                      child: const Icon(Icons.check_circle, color: Colors.white, size: 32),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle),
                        SizedBox(width: 10),
                        Text('Place Order'),
                      ],
                    ),
        ),
      ),
    );
  }
} 