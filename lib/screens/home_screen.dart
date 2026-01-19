import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'customer/customer_home_content.dart';
import 'customer/customer_loads_screen.dart';
import 'customer/customer_tracking_screen.dart';
import 'driver/driver_home_content.dart';
import 'driver/driver_loads_screen.dart';
import 'admin/admin_home_content.dart';
import 'admin/admin_loads_screen.dart';
import 'admin/admin_drivers_screen.dart';
import 'admin/admin_vehicles_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String userRole = authProvider.role;

    List<Widget> screens;
    List<BottomNavigationBarItem> navItems;

    switch (userRole) {
      case 'driver':
        screens = [
          const DriverHomeContent(),
          const DriverLoadsScreen(),
          const ProfileScreen(),
        ];
        navItems = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'My Loads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        break;

      case 'customer':
        screens = [
          const CustomerHomeContent(),
          const CustomerLoadsScreen(),
          const CustomerTrackingScreen(),
          const ProfileScreen(),
        ];
        navItems = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
        break;

      case 'admin':
      default:
        screens = [
          const AdminHomeContent(),
          const AdminLoadsScreen(),
          const AdminDriversScreen(),
          const AdminVehiclesScreen(),
          const ProfileScreen(),
        ];
        navItems = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Loads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Drivers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ];
    }

    if (_selectedIndex >= screens.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        items: navItems,
      ),
    );
  }
}