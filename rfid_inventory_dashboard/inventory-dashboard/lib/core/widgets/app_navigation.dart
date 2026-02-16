import 'package:flutter/material.dart';

class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: const Color(0xFF1E1E2C),
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      indicatorColor: const Color(0xFF2D2D44),

      selectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      selectedLabelTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelTextStyle: const TextStyle(color: Colors.grey),

      destinations: [
        NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.dashboard),
          ),
          label: Text('Dashboard'),
        ),

        NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.add_card),
          ),
          label: Text('Add Card'),
        ),

        NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.list),
          ),
          label: Text('Items'),
        ),

        NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.people),
          ),
          label: Text('Handlers'),
        ),

        NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.history),
          ),
          label: Text('Logs'),
        ),
      ],
    );
  }
}
