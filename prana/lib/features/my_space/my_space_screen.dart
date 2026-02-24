// lib/features/my_space/my_space_screen.dart (WITH TOP TABS)
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'calendar/day_view.dart';
import 'add_event_screen.dart';
import 'services/calendar_storage.dart';
import 'services/notification_service.dart';
import 'models/event_model.dart';
import 'widgets/emoji_legend.dart';
import 'widgets/week_vibe_card.dart';
import 'widgets/quick_add_bar.dart';
import 'widgets/dreamy_background.dart';
import 'screens/notification_settings_screen.dart';
import 'theme/card_styles.dart';
import '../../widgets/ultimate_emoji.dart';
import 'my_rhythm_screen.dart'; // New import

class MySpaceScreen extends StatefulWidget {
  final Map<String, dynamic>? parentData;
  
  const MySpaceScreen({super.key, this.parentData});

  @override
  State<MySpaceScreen> createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends State<MySpaceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  late CalendarStorage _storage;
  late NotificationService _notificationService;
  List<EventModel> _events = [];
  
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  bool _isLoading = true;

  // Get priority emoji for calendar display
  String _getPriorityEmoji(List<EventModel> events) {
    if (events.isEmpty) return '';
    
    if (events.any((e) => e.category == 'urgent')) return '⚠️';
    if (events.any((e) => e.category == 'exam')) return '📝';
    
    return events.first.emoji;
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    _storage = CalendarStorage();
    _notificationService = NotificationService();
    _loadEvents();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    final events = await _storage.getEvents();
    setState(() {
      _events = events;
      _isLoading = false;
    });
    
    _notificationService.checkStudyBalance(events);
    
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour <= 9) {
      _notificationService.sendMorningSummary(events);
    }
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events.where((event) => 
      event.date.year == day.year && 
      event.date.month == day.month && 
      event.date.day == day.day
    ).toList();
  }

  Map<DateTime, List<EventModel>> _getGroupedEvents() {
    Map<DateTime, List<EventModel>> grouped = {};
    for (var event in _events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(event);
    }
    return grouped;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<EventModel> _getUpcomingEvents() {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final dayAfter = DateTime(today.year, today.month, today.day + 2);
    final thirdDay = DateTime(today.year, today.month, today.day + 3);
    
    return _events.where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return (eventDate.isAtSameMomentAs(tomorrow) ||
              eventDate.isAtSameMomentAs(dayAfter) ||
              eventDate.isAtSameMomentAs(thirdDay)) &&
             event.date.isAfter(DateTime.now());
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  String _getEmojiForDate(DateTime date) {
    final dayEvents = _getEventsForDay(date);
    if (dayEvents.isEmpty) return '';
    
    if (dayEvents.any((e) => e.category == 'urgent')) return '⚠️';
    if (dayEvents.any((e) => e.category == 'exam')) return '📝';
    
    return dayEvents.first.emoji;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _getGroupedEvents();
    final dayEvents = _getEventsForDay(_selectedDay);
    final upcomingEvents = _getUpcomingEvents();
    final todayEvents = _getEventsForDay(DateTime.now());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DreamyBackground(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // App Bar with Title
                SliverAppBar(
                  expandedHeight: 100,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '🏠 ',
                              style: TextStyle(fontSize: 24, color: Color(0xFF2D3E50)),
                            ),
                            Text(
                              'MY SPACE',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3E50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _tabController.index == 0 
                              ? 'Your personal command center'
                              : 'Your daily rhythm & habits',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF2D3E50).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Tab Bar
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF2D3E50),
                      indicatorWeight: 3,
                      labelColor: const Color(0xFF2D3E50),
                      unselectedLabelColor: const Color(0xFF2D3E50).withOpacity(0.5),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('📅 ', style: TextStyle(fontSize: 18)),
                              Text('MY SPACE'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('⏰ ', style: TextStyle(fontSize: 18)),
                              Text('MY RHYTHM'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // MY SPACE TAB (Calendar View)
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadEvents,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Calendar Card
                              CardStyles.wrapWithFrostedGlass(
                                tintColor: const Color(0xFFB4A7F5),
                                opacity: 0.15,
                                child: TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  calendarFormat: CalendarFormat.month,
                                  eventLoader: (day) {
                                    final events = groupedEvents[DateTime(day.year, day.month, day.day)];
                                    return events ?? [];
                                  },
                                  calendarStyle: CalendarStyle(
                                    markerDecoration: const BoxDecoration(
                                      color: Color(0xFF2D3E50),
                                      shape: BoxShape.circle,
                                    ),
                                    todayDecoration: BoxDecoration(
                                      color: const Color(0xFF2D3E50).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: const Color(0xFF2D3E50).withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    defaultTextStyle: const TextStyle(
                                      color: Color(0xFF2D3E50),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    weekendTextStyle: const TextStyle(
                                      color: Color(0xFF2D3E50),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3E50),
                                    ),
                                    leftChevronIcon: const Icon(Icons.chevron_left, color: Color(0xFF2D3E50), size: 20),
                                    rightChevronIcon: const Icon(Icons.chevron_right, color: Color(0xFF2D3E50), size: 20),
                                    titleTextFormatter: (date, locale) => 
                                        '📅 ${DateFormat('MMMM yyyy').format(date).toUpperCase()}',
                                  ),
                                  daysOfWeekStyle: const DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3E50),
                                    ),
                                    weekendStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  onDaySelected: _onDaySelected,
                                  calendarBuilders: CalendarBuilders(
                                    markerBuilder: (context, date, events) {
                                      if (events.isEmpty) return null;
                                      
                                      final emoji = _getEmojiForDate(date);
                                      if (emoji.isEmpty) return null;
                                      
                                      return Positioned(
                                        bottom: 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          child: UltimateEmoji(
                                            emoji: emoji,
                                            size: 10,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Today's Highlights
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('📋 ', style: TextStyle(fontSize: 18)),
                                      Text(
                                        'TODAY\'S HIGHLIGHTS',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3E50),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(50, 30),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Color(0xFF2D3E50),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Today's Events
                              if (todayEvents.isEmpty)
                                CardStyles.wrapWithFrostedGlass(
                                  tintColor: const Color(0xFFFFB7B2),
                                  opacity: 0.15,
                                  padding: const EdgeInsets.all(12),
                                  child: const Row(
                                    children: [
                                      UltimateEmoji(emoji: '🌊', size: 24),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'No events today. Tap + to add one!',
                                          style: TextStyle(
                                            color: Color(0xFF2D3E50),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ...todayEvents.map((event) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddEventScreen(eventToEdit: event),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadEvents();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: CardStyles.eventCard(event.category),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2D3E50).withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(18),
                                              ),
                                              child: Center(
                                                child: UltimateEmoji(emoji: event.emoji, size: 18),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    event.startTime != null
                                                        ? DateFormat('h:mm a').format(
                                                            DateTime(
                                                              event.date.year,
                                                              event.date.month,
                                                              event.date.day,
                                                              event.startTime!.hour,
                                                              event.startTime!.minute,
                                                            ),
                                                          )
                                                        : 'All day',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF2D3E50),
                                                    ),
                                                  ),
                                                  Text(
                                                    event.title,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF2D3E50),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Color(0xFF2D3E50),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              
                              const SizedBox(height: 20),
                              
                              // Add Event Button
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEventScreen(initialDate: _selectedDay),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadEvents();
                                    }
                                  },
                                  icon: const Icon(Icons.add, color: Color(0xFF2D3E50), size: 18),
                                  label: const Text(
                                    'ADD EVENT',
                                    style: TextStyle(
                                      color: Color(0xFF2D3E50),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  style: CardStyles.primaryButton,
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Quick Add Bar
                              CardStyles.wrapWithFrostedGlass(
                                tintColor: const Color(0xFFA3E4D7),
                                opacity: 0.15,
                                padding: const EdgeInsets.all(16),
                                child: QuickAddBar(
                                  selectedDay: _selectedDay,
                                  onEventAdded: _loadEvents,
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Emoji Legend
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE5A3).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                child: const EmojiLegend(),
                              ),
                            ],
                          ),
                        ),
                      ),
                
                // MY RHYTHM TAB (Daily Routine)
                const MyRhythmScreen(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF2D3E50),
          foregroundColor: Colors.white,
          elevation: 0,
          mini: true,
          child: const Icon(Icons.notifications_active, size: 18),
        ),
      ),
    );
  }
}

// Helper delegate for SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}