import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Modèle pour une destination de navigation.
class NavigationDestinationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? badgeCount;

  const NavigationDestinationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

/// Barre de navigation verticale entièrement personnalisable.
class CustomVerticalNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestinationItem> destinations;
  final bool extended;
  final VoidCallback? onToggleExtended;
  final Widget? leading;
  final Widget? trailing;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final double extendedWidth;
  final double collapsedWidth;
  final Duration animationDuration;

  const CustomVerticalNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = true,
    this.onToggleExtended,
    this.leading,
    this.trailing,
    this.backgroundColor = Colors.white,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.extendedWidth = 256,
    this.collapsedWidth = 95,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      width: extended ? extendedWidth : collapsedWidth,
      color: backgroundColor,
      child: Column(
        children: [
          SizedBox(height: 25,),
          Row(
            children: [
              if (leading != null) leading!,
              if (onToggleExtended != null) _buildToggleButton(),
            ],
          ),
          const Spacer(),
          ...destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;
            return _buildDestinationItem(
              item: item,
              isSelected: isSelected,
              onTap: () => onDestinationSelected(index),
            );
          }),
          const Spacer(),
          if (trailing != null) trailing!,
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildDestinationItem({
    required NavigationDestinationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: activeColor, width: 1.5) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            if (extended) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (item.badgeCount != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.badgeCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return IconButton(
      onPressed: onToggleExtended,
      icon: Icon(extended ? Icons.chevron_left : Icons.chevron_right, color: AppColors.scaffoldBackground, size: 35,),
      tooltip: extended ? 'Réduire le menu' : 'Étendre le menu',
    );
  }
}


















