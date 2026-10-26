import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/features/auth/domain/entities/user.dart';
import 'package:baobab_business/features/main/presentation/widgets/custom_vertical_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String businessId;

  const MainScreen({
    super.key,
    required this.navigationShell,
    required this.businessId,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isExtended = true;

  void _toggleExtended() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        return isTablet ? _buildTabletLayout(user) : _buildMobileLayout();
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) => widget.navigationShell.goBranch(index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Commandes'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Équipe'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), activeIcon: Icon(Icons.campaign), label: 'Pub'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Boutique'),
        ],
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildTabletLayout(User? user) {
    final destinations = [
      const NavigationDestinationItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard',
      ),
      const NavigationDestinationItem(
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Stock',
      ),
      const NavigationDestinationItem(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'Commandes',
      ),
      const NavigationDestinationItem(
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        label: 'Équipe',
      ),
      const NavigationDestinationItem(
        icon: Icons.campaign_outlined,
        selectedIcon: Icons.campaign,
        label: 'Publicité',
      ),
      const NavigationDestinationItem(
        icon: Icons.storefront_outlined,
        selectedIcon: Icons.storefront,
        label: 'Boutique',
      ),
    ];

    final leading = _buildLeading();
    final trailing = _buildTrailing(user);

    return Scaffold(
      body: Container(
        child: Row(
          children: [
            CustomVerticalNavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (index) => widget.navigationShell.goBranch(index),
              destinations: destinations,
              extended: _isExtended,
              onToggleExtended: _toggleExtended,
              leading: leading,
              trailing: trailing,
              backgroundColor: AppColors.secondary,
              activeColor: AppColors.scaffoldBackground,
              inactiveColor: AppColors.scaffoldBackground,
            ),
            const VerticalDivider(thickness: 1, width: 5),
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/icons/calendar-date-svgrepo-com (1).svg",
              width: _isExtended ? 50 : 35,
              height: _isExtended ? 50 : 35,
              colorFilter: const ColorFilter.mode(AppColors.scaffoldBackground, BlendMode.srcIn),
            ),
          ),
          if (_isExtended) ...[
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                "Baobabe",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.scaffoldBackground,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrailing(User? user) {
    if (user == null) return const SizedBox.shrink();
    return LayoutBuilder(builder: (context, box) {
      // Étroit (animation ou barre réduite) : avatar seul, sans débordement.
      final wide = _isExtended && box.maxWidth >= 200;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: _isExtended ? 24 : 20,
          backgroundColor: Colors.green.shade100,
          backgroundImage: (user.imgUrl != null && user.imgUrl!.isNotEmpty)
              ? NetworkImage(user.imgUrl!)
              : null,
          child: user.imgUrl == null
              ? Text(_getInitials(user.name), style: const TextStyle(fontSize: 14))
              : null,
        ),

        if (wide) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name.split(' ').first,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.scaffoldBackground),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              const Text('Commerçant', style: TextStyle(fontSize: 11, color: AppColors.scaffoldBackground)),
            ],
          ),
          ),
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
            icon: const Icon(Icons.logout, color: AppColors.scaffoldBackground,),
            tooltip: 'Déconnexion',
          ),
        ],
      ],
    );
    });
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}