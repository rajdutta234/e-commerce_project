import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;
  var sort = 'A-Z'.obs;

  void setCategories(List<CategoryModel> list) {
    categories.assignAll(list);
  }

  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
  }

  List<CategoryModel> get filteredCategories {
    var cats = categories.toList();
    if (searchQuery.value.isNotEmpty) {
      cats = cats.where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    if (sort.value == 'A-Z') {
      cats.sort((a, b) => a.name.compareTo(b.name));
    } else if (sort.value == 'Z-A') {
      cats.sort((a, b) => b.name.compareTo(a.name));
    }
    return cats;
  }
} 