import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var selectedProduct = Rxn<ProductModel>();
  var searchQuery = ''.obs;

  void setProducts(List<ProductModel> list) {
    products.assignAll(list);
  }

  void selectProduct(ProductModel? product) {
    selectedProduct.value = product;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
} 