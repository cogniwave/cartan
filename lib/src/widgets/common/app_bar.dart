import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.borderRadius = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    final TextStyle? titleTextStyle = theme.appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading && canPop) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.zero,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.dividerTheme.color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            if (leadingWidget != null) leadingWidget,
            if (leadingWidget != null) const SizedBox(width: 8),
            Expanded(
              child: DefaultTextStyle(
                style: titleTextStyle!,
                child: title,
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}