import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onSearch;
  final int? cartCount;
  final int? wishlistCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onWishlistTap,
    this.onProfileTap,
    this.onSearch,
    this.cartCount,
    this.wishlistCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Ensure ProfileController is available
    final ProfileController profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    return Material(
      elevation: 4,
      color: colorScheme.surface,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 49,
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 16, top: 2, bottom: 0),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.menu, size: 28),
                        onPressed: onMenuTap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: colorScheme.primary),
                      ),
                    ),
                    Obx(() {
                      final user = profileController.user.value;
                      return user != null && user.name.isNotEmpty
                          ? Text(
                              user.name,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: colorScheme.primary),
                              overflow: TextOverflow.ellipsis,
                            )
                          : const SizedBox();
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  double searchBarWidth = width > 900
                      ? 500
                      : width > 600
                          ? 380
                          : width;
                  return Center(
                    child: SizedBox(
                      width: searchBarWidth,
                      height: 35,
                      child: _ModernSearchBar(onSearch: onSearch),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(96);
}

class _ModernSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final List<String>? suggestions;
  const _ModernSearchBar({this.onSearch, this.suggestions});
  @override
  State<_ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<_ModernSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _recentSearches = <String>[];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          onChanged: (val) {
            widget.onSearch?.call(val);
            setState(() {
              _showSuggestions = val.isNotEmpty && _recentSearches.isNotEmpty;
            });
          },
          style: GoogleFonts.poppins(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      if (widget.onSearch != null) widget.onSearch!("");
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surfaceVariant,
          ),
          onTap: () => setState(() {
            _showSuggestions = _controller.text.isNotEmpty && _recentSearches.isNotEmpty;
          }),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty && !_recentSearches.contains(val.trim())) {
              setState(() {
                _recentSearches.insert(0, val.trim());
                if (_recentSearches.length > 5) _recentSearches.removeLast();
                _showSuggestions = false;
              });
            }
          },
        ),
        if (_showSuggestions)
          SizedBox(
            height: 120, // max height for dropdown
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: _recentSearches
                    .where((s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
                    .map((s) => ListTile(
                          title: Text(s),
                          leading: const Icon(Icons.history, size: 18),
                          onTap: () {
                            _controller.text = s;
                            widget.onSearch?.call(s);
                            setState(() {
                              _showSuggestions = false;
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
} 