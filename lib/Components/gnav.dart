import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nofap/screens/Pages/Home/homescreen.dart';
import 'package:nofap/screens/Rewards/rewards.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages =  [
    HomeScreen(),
    Page2(),
    SimpleAudioScreen(),
  ];

  static const Color backgroundColor = Color(0xFFF9FAFB); // main bg
  static const Color barColor = Color(0xFFFFFFFF); // navbar bg
  static const Color activeColor = Color(0xFF2563EB); // active icon
  static const Color inactiveColor = Color(0xFF9CA3AF); // inactive icon

  Color getFloatingButtonColor() {
    if (selectedIndex == 0) return Colors.red.shade300;
    if (selectedIndex == 1) return Colors.green.shade300;
    return const Color.fromARGB(255, 229, 189, 56); 
  }

  List<Widget> get navItems => [
        const Icon(Icons.home, size: 28),
        const Icon(Icons.search, size: 28),
        const Icon(Icons.person, size: 28),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        letIndexChange: (index) => true,
        height: 60,
        items: navItems.map((icon) {
          int index = navItems.indexOf(icon);
          return Icon(
            (icon as Icon).icon,
            size: 28,
            color: selectedIndex == index ? const Color.fromARGB(255, 250, 250, 250) : const Color.fromARGB(255, 39, 105, 219),
          );
        }).toList(),
        color: const Color.fromARGB(255, 255, 242, 242),
        buttonBackgroundColor: getFloatingButtonColor(),
        backgroundColor: backgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ---------------- Pages ---------------- //

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home, size: 64, color: Color(0xFF2563EB)),
            SizedBox(height: 16),
            Text('Home',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Welcome to your dashboard',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, size: 64),
            SizedBox(height: 16),
            Text('Search',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Find what you need',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}
