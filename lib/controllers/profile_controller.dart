import 'package:get/get.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  var user = Rxn<UserModel>();
  var notificationsEnabled = true.obs;
  var addresses = <String>[].obs;
  var selectedAddressIndex = 0.obs;
  var recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Set a mock user for testing
    user.value = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      avatar: 'https://i.pravatar.cc/150?img=1',
      address: '123 Main St, City',
    );
  }

  void updateUser(UserModel? newUser) {
    user.value = newUser;
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void addAddress(String address) {
    addresses.add(address);
    selectedAddressIndex.value = addresses.length - 1;
    updateUser(user.value?.copyWith(address: address));
  }

  void editAddress(int index, String newAddress) {
    addresses[index] = newAddress;
    if (selectedAddressIndex.value == index) {
      updateUser(user.value?.copyWith(address: newAddress));
    }
    addresses.refresh();
  }

  void deleteAddress(int index) {
    addresses.removeAt(index);
    if (addresses.isEmpty) {
      selectedAddressIndex.value = 0;
      updateUser(user.value?.copyWith(address: ''));
    } else {
      selectedAddressIndex.value = 0;
      updateUser(user.value?.copyWith(address: addresses[0]));
    }
  }

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
    updateUser(user.value?.copyWith(address: addresses[index]));
  }

  void addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    if (!recentSearches.contains(query.trim())) {
      recentSearches.insert(0, query.trim());
      if (recentSearches.length > 8) recentSearches.removeLast();
    }
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }
}

extension UserModelCopy on UserModel {
  UserModel copyWith({
    String? name,
    String? email,
    String? avatar,
    String? address,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
    );
  }
} 