import 'package:get/get.dart';
import '../views/landing/landing_page.dart';
import '../views/cart/cart_page.dart';
import '../views/wishlist/wishlist_page.dart';
import '../views/categories/category_page.dart';
import '../views/product/product_detail_page.dart';
import '../views/product/product_list_page.dart';
import '../views/profile/profile_page.dart';
import '../views/orders/order_history_page.dart';
import '../bindings/cart_binding.dart';
import '../bindings/wishlist_binding.dart';
import '../bindings/category_binding.dart';
import '../bindings/product_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/home_binding.dart';
import '../views/profile/edit_profile_page.dart';
import '../views/cart/checkout_page.dart';
import '../views/profile/delivery_address_page.dart';
import '../views/profile/address_book_page.dart';
import '../views/search_page.dart';

part 'app_routes.dart';

class AppPages {
  static String get initial => Routes.landing;

  static final routes = [
    GetPage(
      name: Routes.landing,
      page: () => const LandingPage(),
      bindings: [HomeBinding(), CartBinding()],
    ),
    GetPage(
      name: '/cart',
      page: () => const CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: '/wishlist',
      page: () => const WishlistPage(),
      bindings: [WishlistBinding(), CartBinding()],
    ),
    GetPage(
      name: '/categories',
      page: () => const CategoryPage(),
      bindings: [CategoryBinding(), CartBinding(), WishlistBinding()],
    ),
    GetPage(
      name: '/product_detail',
      page: () => const ProductDetailPage(),
      bindings: [ProductBinding(), CartBinding()],
    ),
    GetPage(
      name: '/product_list',
      page: () => const ProductListPage(),
      bindings: [ProductBinding(), CartBinding()],
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfilePage(),
      bindings: [ProfileBinding(), CartBinding()],
    ),
    GetPage(
      name: '/orders',
      page: () => const OrderHistoryPage(),
    ),
    GetPage(
      name: '/edit_profile',
      page: () => const EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/checkout',
      page: () => const CheckoutPage(),
      bindings: [ProfileBinding(), CartBinding()],
    ),
    GetPage(
      name: '/delivery_address',
      page: () => const DeliveryAddressPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/address_book',
      page: () => const AddressBookPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchPage(),
    ),
  ];
} 