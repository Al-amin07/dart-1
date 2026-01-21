import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/load_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/notification_badge.dart';
import 'create_driver_profile_screen.dart';
import 'create_vehicle_screen.dart';
import 'admin_loads_screen.dart';
import 'admin_drivers_screen.dart';
import 'admin_vehicles_screen.dart';
import 'admin_analytics_screen.dart';

class AdminHomeContent extends StatefulWidget {
  const AdminHomeContent({super.key});

  @override
  State<AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<AdminHomeContent> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  final List<BannerData> _banners = [
    BannerData(
      title: 'Manage Your Fleet',
      subtitle: 'Track all your vehicles in real-time',
      color: Colors.blue,
      icon: Icons.local_shipping,
    ),
    BannerData(
      title: 'Assign Drivers',
      subtitle: 'Efficiently manage your driver assignments',
      color: Colors.green,
      icon: Icons.person,
    ),
    BannerData(
      title: 'Track Loads',
      subtitle: 'Monitor deliveries from start to finish',
      color: Colors.orange,
      icon: Icons.inventory_2,
    ),
    BannerData(
      title: 'Analyze Performance',
      subtitle: 'Make data-driven decisions',
      color: Colors.purple,
      icon: Icons.analytics,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _loadData();
  }

  void _loadData() {
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    
    loadProvider.fetchAllLoads();
    loadProvider.fetchLoadStats();
    driverProvider.fetchAllDrivers();
    vehicleProvider.fetchAllVehicles();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader('Admin Dashboard'),
                const SizedBox(height: 20),
                _buildBannerSection(),
                const SizedBox(height: 30),
                _buildQuickStats(),
                const SizedBox(height: 30),
                _buildTodayOverview(),
                const SizedBox(height: 30),
                _buildQuickActions(),
                const SizedBox(height: 30),
                _buildRecentActivity(),
                const SizedBox(height: 30),
                _buildFleetStatus(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    final authProvider = Provider.of<AuthProvider>(context);
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting,',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.user?.name ?? title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const NotificationBadge(),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 30,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                const SizedBox(width: 12),
                Text(
                  'Search loads, drivers, vehicles...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return _buildBannerCard(_banners[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentBannerIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentBannerIndex == index
                      ? Colors.blue
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BannerData banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [banner.color, banner.color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: banner.color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              banner.icon,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final loadProvider = Provider.of<LoadProvider>(context);
    final driverProvider = Provider.of<DriverProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final stats = loadProvider.stats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Loads',
                  '${(stats?['assigned'] ?? 0) + (stats?['inTransit'] ?? 0)}',
                  Icons.local_shipping,
                  Colors.blue,
                  '+8.5%',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  '${stats?['pending'] ?? 0}',
                  Icons.pending,
                  Colors.orange,
                  '+12%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Drivers',
                  '${driverProvider.drivers.where((d) => d.status == 'available' || d.status == 'on-duty').length}',
                  Icons.person,
                  Colors.green,
                  '+5.2%',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Vehicles',
                  '${vehicleProvider.vehicles.length}',
                  Icons.directions_car,
                  Colors.purple,
                  '+3.1%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    final isPositive = change.startsWith('+');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayOverview() {
    final loadProvider = Provider.of<LoadProvider>(context);
    final stats = loadProvider.stats;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[700]!, Colors.indigo[500]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateTime.now().toString().split(' ')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewStat('Completed', '${stats?['delivered'] ?? 0}', Icons.check_circle),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: _buildOverviewStat('In Progress', '${stats?['inTransit'] ?? 0}', Icons.local_shipping),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: _buildOverviewStat('Revenue', '\$2.5K', Icons.attach_money),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildBeautifulActionCard(
                  'Assign Load',
                  Icons.assignment,
                  Colors.blue,
                  'Assign pending loads',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminLoadsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildBeautifulActionCard(
                  'Add Driver',
                  Icons.person_add,
                  Colors.green,
                  'Register new driver',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateDriverProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildBeautifulActionCard(
                  'Add Vehicle',
                  Icons.directions_car,
                  Colors.orange,
                  'Register vehicle',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateVehicleScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildBeautifulActionCard(
                  'Analytics',
                  Icons.analytics,
                  Colors.purple,
                  'View reports',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminAnalyticsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeautifulActionCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminLoadsScreen(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildActivityTile(
            'New order created',
            'LOAD-1005 from Customer ABC',
            Icons.add_circle,
            Colors.green,
            '5 min ago',
          ),
          _buildActivityTile(
            'Driver assigned',
            'John Doe assigned to LOAD-1004',
            Icons.person,
            Colors.blue,
            '15 min ago',
          ),
          _buildActivityTile(
            'Delivery completed',
            'LOAD-1003 delivered successfully',
            Icons.check_circle,
            Colors.purple,
            '1 hour ago',
          ),
          _buildActivityTile(
            'Vehicle registered',
            'Mercedes Sprinter added to fleet',
            Icons.directions_car,
            Colors.orange,
            '2 hours ago',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, IconData icon, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFleetStatus() {
    final driverProvider = Provider.of<DriverProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    
    final availableDrivers = driverProvider.drivers.where((d) => d.status == 'available').length;
    final onDutyDrivers = driverProvider.drivers.where((d) => d.status == 'on-duty').length;
    final availableVehicles = vehicleProvider.vehicles.where((v) => v.status == 'available').length;
    final inUseVehicles = vehicleProvider.vehicles.where((v) => v.status == 'in-use').length;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fleet Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildFleetCard(
                  'Drivers',
                  availableDrivers,
                  onDutyDrivers,
                  Icons.person,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDriversScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildFleetCard(
                  'Vehicles',
                  availableVehicles,
                  inUseVehicles,
                  Icons.local_shipping,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminVehiclesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFleetCard(String title, int available, int active, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$available',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$active Active',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  BannerData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}