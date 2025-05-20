import 'package:flutter/material.dart';

class SearchableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function(String) onSearch;
  final List<Widget> trailingActions;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? searchStyle;
  final String searchHint;

  const SearchableAppBar({
    super.key,
    required this.title,
    required this.onSearch,
    this.trailingActions = const [],
    this.backgroundColor,
    this.titleStyle,
    this.searchStyle,
    this.searchHint = 'Search',
  });

  @override
  State<SearchableAppBar> createState() => _SearchableAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchableAppBarState extends State<SearchableAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      widget.onSearch(''); // Clear search results
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: widget.backgroundColor ?? theme.appBarTheme.backgroundColor,
      title: _isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.6)),
        ),
        style: widget.searchStyle ?? TextStyle(color: theme.colorScheme.onSurface),
        onChanged: widget.onSearch,
      )
          : Text(
        widget.title,
        style: widget.titleStyle,
      ),
      actions: [
        if (_isSearching)
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.primary),
            onPressed: _stopSearch,
          )
        else
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.primary),
            onPressed: _startSearch,
          ),
        ...(_isSearching ? [] : widget.trailingActions),
      ],
    );
  }
}