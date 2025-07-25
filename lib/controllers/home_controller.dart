import 'package:get/get.dart';
import '../models/product_model.dart';

class HomeController extends GetxController {
  var featuredProducts = <ProductModel>[].obs;
  var bannerImage = ''.obs;

  void setFeaturedProducts(List<ProductModel> list) {
    featuredProducts.assignAll(list);
  }

  void setBannerImage(String imageUrl) {
    bannerImage.value = imageUrl;
  }
} 