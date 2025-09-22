import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------- CONTROLLERS ----------------

class HomeController extends GetxController {
  var days = 0.obs;
  var isLoading = true.obs;
  var currentQuoteIndex = 0.obs;

  final List<String> motivationalQuotes = [
    "Every moment you resist is a moment you grow stronger.",
    "Discipline is choosing between what you want now and what you want most.",
    "Your future self will thank you for the choices you make today.",
    "Strength doesn't come from what you can do. It comes from overcoming what you thought you couldn't.",
    "The pain of discipline weighs ounces, but the pain of regret weighs tons.",
    "You are not your urges. You are the one who chooses whether to act on them.",
    "Recovery is not a destination, it's a journey of daily choices.",
    "Every day clean is a victory worth celebrating.",
    "Progress, not perfection, is the goal.",
    "Your willpower is like a muscle – the more you use it, the stronger it gets.",
    "Champions are made when nobody's watching.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "You didn't come this far to only come this far.",
    "Small steps every day lead to big changes over time.",
    "Your mind is powerful. When you fill it with positive thoughts, your life will start to change.",
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDays();
    _setDailyQuote();
  }

  void _setDailyQuote() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    currentQuoteIndex.value = dayOfYear % motivationalQuotes.length;
  }

  String get dailyQuote => motivationalQuotes[currentQuoteIndex.value];

  Future<void> _loadDays() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('nofap_first_launch_date')) {
      await prefs.setString(
        'nofap_first_launch_date',
        DateTime.now().toIso8601String(),
      );
    }

    final firstDate = DateTime.parse(
      prefs.getString('nofap_first_launch_date')!,
    );
    final now = DateTime.now();
    days.value = now.difference(firstDate).inDays + 1;
    isLoading.value = false;
  }

  Future<void> resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'nofap_first_launch_date',
      DateTime.now().toIso8601String(),
    );
    _loadDays();
  }

  String get badge {
    if (days.value >= 365) return "🏆 Champion";
    if (days.value >= 180) return "💎 Diamond";
    if (days.value >= 90) return "🥇 Gold Streak";
    if (days.value >= 30) return "🥈 Silver Streak";
    if (days.value >= 7) return "🥉 Bronze Streak";
    return "🌱 Starting Strong";
  }

  String get nextMilestone {
    if (days.value < 7) return "7 days";
    if (days.value < 30) return "30 days";
    if (days.value < 90) return "90 days";
    if (days.value < 180) return "180 days";
    if (days.value < 365) return "1 year";
    return "New record!";
  }

  int get daysToNextMilestone {
    if (days.value < 7) return 7 - days.value;
    if (days.value < 30) return 30 - days.value;
    if (days.value < 90) return 90 - days.value;
    if (days.value < 180) return 180 - days.value;
    if (days.value < 365) return 365 - days.value;
    return 0;
  }

  double get progressToNextMilestone {
    if (days.value < 7) return days.value / 7;
    if (days.value < 30) return (days.value - 7) / 23;
    if (days.value < 90) return (days.value - 30) / 60;
    if (days.value < 180) return (days.value - 90) / 90;
    if (days.value < 365) return (days.value - 180) / 185;
    return 1.0;
  }

  List<Map<String, dynamic>> get achievements {
    List<Map<String, dynamic>> earned = [];
    if (days.value >= 1)
      earned.add({
        "title": "First Day",
        "icon": "🎯",
        "desc": "Started your journey",
      });
    if (days.value >= 3)
      earned.add({
        "title": "3 Days",
        "icon": "🔥",
        "desc": "Building momentum",
      });
    if (days.value >= 7)
      earned.add({
        "title": "One Week",
        "icon": "⭐",
        "desc": "First milestone reached",
      });
    if (days.value >= 30)
      earned.add({
        "title": "One Month",
        "icon": "💪",
        "desc": "Serious commitment",
      });
    if (days.value >= 90)
      earned.add({
        "title": "90 Days",
        "icon": "🏅",
        "desc": "Major transformation",
      });
    if (days.value >= 180)
      earned.add({
        "title": "6 Months",
        "icon": "💎",
        "desc": "Lifestyle change",
      });
    if (days.value >= 365)
      earned.add({"title": "One Year", "icon": "👑", "desc": "Life mastery"});
    return earned;
  }

  String get healthBenefit {
    if (days.value >= 90) return "Peak confidence and mental clarity";
    if (days.value >= 60) return "Significantly improved focus and energy";
    if (days.value >= 30) return "Better sleep and increased motivation";
    if (days.value >= 14) return "Improved mood and self-confidence";
    if (days.value >= 7) return "Higher energy levels and better focus";
    if (days.value >= 3) return "Initial dopamine regulation beginning";
    return "Brain starting to reset and recover";
  }
}

class ThoughtsController extends GetxController {
  var thoughts = <String>[].obs;
  final inputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadThoughts();
  }

  Future<void> _loadThoughts() async {
    final prefs = await SharedPreferences.getInstance();
    thoughts.value = prefs.getStringList('nofap_thoughts') ?? [];
  }

  Future<void> _saveThoughts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nofap_thoughts', thoughts);
  }

  void addThought() {
    if (inputController.text.trim().isEmpty) return;
    final now = DateTime.now();
    final ts =
        '${now.day}/${now.month} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    thoughts.insert(0, '[$ts] ${inputController.text.trim()}');
    inputController.clear();
    _saveThoughts();
  }

  void deleteThought(int index) {
    thoughts.removeAt(index);
    _saveThoughts();
  }
}

/// ---------------- MAIN SCREEN ----------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final hc = Get.put(HomeController());
    final tc = Get.put(ThoughtsController());
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF238636)
                    : const Color(0xFF2DA44E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "NoFap Tracker",
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF24292F),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.chart_bar_alt_fill,
              color: isDark ? Colors.white70 : const Color(0xFF656D76),
            ),
            onPressed: () => _showStatsDialog(context, hc),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.refresh,
              color: isDark ? Colors.white70 : const Color(0xFF656D76),
            ),
            onPressed: () => _showResetDialog(context, hc),
          ),
        ],
      ),
      body: Obx(() {
        if (hc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : const Color(0xFFE1E4E8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${hc.days}",
                          style: TextStyle(
                            fontSize: 200,
                            fontWeight: FontWeight.w300,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF24292F),
                            height: 1.0,
                            fontFamily: 'Chillax'
                          ),
                        ),
                        
                        Text(
                          hc.days.value == 1 ? "DAY CLEAN" : "DAYS CLEAN",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: isDark
                                ? const Color(0xFF8B949E)
                                : const Color(0xFF656D76),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(hc.badge, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF21262D)
                                : const Color(0xFFF6F8FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            hc.healthBenefit,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF58A6FF)
                                  : const Color(0xFF0969DA),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (hc.daysToNextMilestone > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF30363D)
                            : const Color(0xFFE1E4E8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Next Milestone",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF24292F),
                              ),
                            ),
                            Text(
                              "${hc.daysToNextMilestone} days to go",
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? const Color(0xFF8B949E)
                                    : const Color(0xFF656D76),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: hc.progressToNextMilestone,
                          backgroundColor: isDark
                              ? const Color(0xFF30363D)
                              : const Color(0xFFE1E4E8),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? const Color(0xFF238636)
                                : const Color(0xFF2DA44E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Goal: ${hc.nextMilestone}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF238636)
                                : const Color(0xFF2DA44E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Daily Quote
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : const Color(0xFFE1E4E8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF21262D)
                                  : const Color(0xFFF6F8FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              CupertinoIcons.quote_bubble,
                              size: 20,
                              color: isDark
                                  ? const Color(0xFFFFA657)
                                  : const Color(0xFFBF8700),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Daily Motivation",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF24292F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hc.dailyQuote,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? const Color(0xFF8B949E)
                              : const Color(0xFF656D76),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Achievements
                if (hc.achievements.isNotEmpty) ...[
                  Text(
                    "ACHIEVEMENTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: isDark
                          ? const Color(0xFF8B949E)
                          : const Color(0xFF656D76),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF30363D)
                            : const Color(0xFFE1E4E8),
                      ),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: hc.achievements.map((achievement) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF21262D)
                                : const Color(0xFFF6F8FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF30363D)
                                  : const Color(0xFFE1E4E8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                achievement["icon"],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                achievement["title"],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF24292F),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],


                // Thoughts Section
                Text(
                  "PERSONAL JOURNAL",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: isDark
                        ? const Color(0xFF8B949E)
                        : const Color(0xFF656D76),
                  ),
                ),
                const SizedBox(height: 12),

                // Add Thought Input
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : const Color(0xFFE1E4E8),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: tc.inputController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF24292F),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              "How are you feeling today? Write your thoughts, goals, or challenges...",
                          hintStyle: TextStyle(
                            color: isDark
                                ? const Color(0xFF8B949E)
                                : const Color(0xFF656D76),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: isDark
                            ? const Color(0xFF30363D)
                            : const Color(0xFFE1E4E8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: tc.addThought,
                              style: TextButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF238636)
                                    : const Color(0xFF2DA44E),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.add, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    "Add Entry",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Thoughts List
                Obx(() {
                  if (tc.thoughts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF30363D)
                              : const Color(0xFFE1E4E8),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.book,
                            size: 48,
                            color: isDark
                                ? const Color(0xFF8B949E)
                                : const Color(0xFF656D76),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Start your journal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF8B949E)
                                  : const Color(0xFF656D76),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Document your thoughts, feelings, and progress on this journey",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? const Color(0xFF8B949E)
                                  : const Color(0xFF656D76),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: tc.thoughts.take(5).map((thought) {
                      final index = tc.thoughts.indexOf(thought);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161B22)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF30363D)
                                : const Color(0xFFE1E4E8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF58A6FF)
                                      : const Color(0xFF0969DA),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  thought,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF24292F),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => tc.deleteThought(index),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF21262D)
                                        : const Color(0xFFF6F8FA),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.trash,
                                    size: 16,
                                    color: isDark
                                        ? const Color(0xFFF85149)
                                        : const Color(0xFFD1242F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showResetDialog(BuildContext context, HomeController hc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Reset Counter?",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF24292F),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "This will reset your ${hc.days} day streak. Are you sure you want to continue?",
          style: TextStyle(
            color: isDark ? const Color(0xFF8B949E) : const Color(0xFF656D76),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF656D76),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              hc.resetCounter();
            },
            style: TextButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFFF85149)
                  : const Color(0xFFD1242F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(BuildContext context, HomeController hc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Your Progress",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF24292F),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatItem(
              "Current Streak",
              "${hc.days} days",
              CupertinoIcons.flame_fill,
            ),
            _StatItem("Current Level", hc.badge, CupertinoIcons.star_fill),
            _StatItem(
              "Health Benefit",
              hc.healthBenefit,
              CupertinoIcons.heart_fill,
            ),
            if (hc.daysToNextMilestone > 0)
              _StatItem(
                "Next Goal",
                "${hc.daysToNextMilestone} days to ${hc.nextMilestone}",
                CupertinoIcons.flag_fill,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF0969DA),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyHelp(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Emergency Support",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF24292F),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "When you're feeling urges:",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF656D76),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _EmergencyTip("🧘", "Take 10 deep breaths"),
            _EmergencyTip("🚶", "Go for a walk outside"),
            _EmergencyTip("🚿", "Take a cold shower"),
            _EmergencyTip("📱", "Call a friend or family"),
            _EmergencyTip("💪", "Do 20 push-ups"),
            _EmergencyTip("📖", "Read or journal"),
            const SizedBox(height: 16),
            Text(
              "Remember: This feeling will pass. You are stronger than your urges.",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF0969DA),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "I Got This",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF238636)
                    : const Color(0xFF2DA44E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommunityInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Join the Community",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF24292F),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Connect with others on the same journey:",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF656D76),
              ),
            ),
            const SizedBox(height: 16),
            _CommunityLink("💬", "r/NoFap Reddit Community"),
            _CommunityLink("📱", "NoFap Official App"),
            _CommunityLink("🌐", "NoFap.com Website"),
            _CommunityLink("📞", "Support Hotlines"),
            const SizedBox(height: 16),
            Text(
              "You're not alone in this journey. Millions are working towards the same goal.",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF0969DA),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF656D76),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- HELPER WIDGETS ----------------

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatItem(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF58A6FF) : const Color(0xFF0969DA),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF8B949E)
                        : const Color(0xFF656D76),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF24292F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyTip extends StatelessWidget {
  final String emoji;
  final String tip;

  const _EmergencyTip(this.emoji, this.tip);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Text(
            tip,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF24292F),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityLink extends StatelessWidget {
  final String emoji;
  final String name;

  const _CommunityLink(this.emoji, this.name);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF24292F),
            ),
          ),
        ],
      ),
    );
  }
}
