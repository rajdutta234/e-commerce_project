import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;
  var total = 0.0.obs;
  var animateCart = false.obs;

  // Payment State
  var selectedPaymentMethod = 'Card'.obs;
  var cardNumber = ''.obs;
  var cardExpiry = ''.obs;
  var cardCvv = ''.obs;
  var upiId = ''.obs;
  var netBankingBank = ''.obs;
  var walletType = ''.obs;

  void addToCart(ProductModel product) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: 1));
    }
    calculateTotal();
    animateCart.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      animateCart.value = false;
    });
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    calculateTotal();
  }

  void updateQuantity(String productId, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity = quantity;
      cartItems.refresh();
      calculateTotal();
    }
  }

  void clearCart() {
    cartItems.clear();
    total.value = 0.0;
  }

  void calculateTotal() {
    total.value = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  bool validatePayment() {
    switch (selectedPaymentMethod.value) {
      case 'Card':
        return cardNumber.value.length == 16 && cardExpiry.value.isNotEmpty && cardCvv.value.length == 3;
      case 'UPI':
        return upiId.value.contains('@');
      case 'NetBanking':
        return netBankingBank.value.isNotEmpty;
      case 'Wallet':
        return walletType.value.isNotEmpty;
      case 'COD':
        return true;
      default:
        return false;
    }
  }
} 