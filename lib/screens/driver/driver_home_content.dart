import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/load_provider.dart';
import '../../providers/driver_provider.dart';
import '../../widgets/notification_badge.dart';
import 'driver_earnings_screen.dart';

class DriverHomeContent extends StatefulWidget {
  const DriverHomeContent({super.key});

  @override
  State<DriverHomeContent> createState() => _DriverHomeContentState();
}

class _DriverHomeContentState extends State<DriverHomeContent> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  final List<BannerData> _driverBanners = [
    BannerData(
      title: 'Safe Driving',
      subtitle: 'Your safety is our priority',
      color: Colors.green,
      icon: Icons.security,
    ),
    BannerData(
      title: 'Track Earnings',
      subtitle: 'Monitor your daily income',
      color: Colors.orange,
      icon: Icons.attach_money,
    ),
    BannerData(
      title: 'Best Routes',
      subtitle: 'Optimized for fuel efficiency',
      color: Colors.blue,
      icon: Icons.route,
    ),
    BannerData(
      title: 'Customer Service',
      subtitle: 'Deliver with a smile',
      color: Colors.purple,
      icon: Icons.sentiment_satisfied_alt,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      loadProvider.fetchLoadsByDriver(authProvider.user!.id);
      loadProvider.fetchActiveLoadForDriver(authProvider.user!.id);
      driverProvider.fetchDriverByUserId(authProvider.user!.id);
    }
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _driverBanners.length;
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
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildBannerSection(),
                const SizedBox(height: 20),
                _buildTodayEarnings(),
                const SizedBox(height: 20),
                _buildCurrentLoad(context),
                const SizedBox(height: 20),
                _buildDriverStats(context),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                _buildRecentDeliveries(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final driverProvider = Provider.of<DriverProvider>(context);
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
          colors: [Colors.green[700]!, Colors.green[500]!],
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
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.user?.name ?? 'Driver',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                      Icons.local_shipping,
                      size: 30,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Status Toggle
          if (driverProvider.selectedDriver != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(driverProvider.selectedDriver!.status),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.circle, color: Colors.white, size: 12),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: driverProvider.selectedDriver!.status,
                    dropdownColor: Colors.green[700],
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: const [
                      DropdownMenuItem(
                        value: 'available',
                        child: Text('Available'),
                      ),
                      DropdownMenuItem(
                        value: 'on-duty',
                        child: Text('On Duty'),
                      ),
                      DropdownMenuItem(
                        value: 'off-duty',
                        child: Text('Off Duty'),
                      ),
                      DropdownMenuItem(
                        value: 'on-leave',
                        child: Text('On Leave'),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        await driverProvider.updateDriverStatus(
                          driverProvider.selectedDriver!.id,
                          value,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'on-duty':
        return Colors.blue;
      case 'off-duty':
        return Colors.grey;
      case 'on-leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 180,
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
              itemCount: _driverBanners.length,
              itemBuilder: (context, index) {
                return _buildBannerCard(_driverBanners[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _driverBanners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentBannerIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentBannerIndex == index
                      ? Colors.green
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
                      fontSize: 22,
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
              size: 70,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayEarnings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DriverEarningsScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[700]!, Colors.amber[500]!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Earnings',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '\$127.50',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '5 deliveries completed',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLoad(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);
    final activeLoad = loadProvider.selectedLoad;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Load',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          if (activeLoad == null)
            Container(
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
                children: [
                  Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No Active Load',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll be notified when assigned',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
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
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.location_on, color: Colors.green[700], size: 28),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeLoad.loadNumber,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${activeLoad.description} - ${activeLoad.weight} kg',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: activeLoad.status == 'in-transit'
                              ? Colors.orange[100]
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activeLoad.status == 'in-transit' ? 'In Transit' : 'Assigned',
                          style: TextStyle(
                            color: activeLoad.status == 'in-transit'
                                ? Colors.orange[700]
                                : Colors.blue[700],
                            fontWeight: FontWeight.bold,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeLoad.pickupAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.grey[400]),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeLoad.deliveryAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: activeLoad.status == 'assigned'
                              ? () async {
                                  await loadProvider.updateLoadStatus(
                                    activeLoad.id,
                                    'in-transit',
                                  );
                                  _loadData();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Start Trip',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: activeLoad.status == 'in-transit'
                              ? () async {
                                  await loadProvider.updateLoadStatus(
                                    activeLoad.id,
                                    'delivered',
                                  );
                                  _loadData();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Complete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDriverStats(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context);
    final driver = driverProvider.selectedDriver;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Deliveries',
                  '${driver?.totalDeliveries ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Rating',
                  '${driver?.rating ?? 5.0} ⭐',
                  Icons.star,
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  Widget _buildQuickActions(BuildContext context) {
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
                child: _buildActionCard(
                  'My Loads',
                  Icons.inventory_2,
                  Colors.blue,
                  () {
                    // Navigate to loads
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  'Earnings',
                  Icons.attach_money,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverEarningsScreen(),
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
                child: _buildActionCard(
                  'Navigation',
                  Icons.navigation,
                  Colors.orange,
                  () {
                    // Open navigation
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  'Support',
                  Icons.support_agent,
                  Colors.purple,
                  () {
                    // Contact support
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
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
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDeliveries() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Deliveries',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildDeliveryTile('LOAD-1003', 'Delivered', '2 hours ago', Colors.green),
          _buildDeliveryTile('LOAD-1002', 'Delivered', '4 hours ago', Colors.green),
          _buildDeliveryTile('LOAD-1001', 'Delivered', 'Yesterday', Colors.green),
        ],
      ),
    );
  }

  Widget _buildDeliveryTile(String loadNumber, String status, String time, Color color) {
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
            child: Icon(Icons.check_circle, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loadNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
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