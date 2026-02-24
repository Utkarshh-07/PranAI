// lib/features/my_space/services/calendar_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class CalendarStorage {
  static const String _eventsKey = 'calendar_events';

  Future<List<EventModel>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsJson = prefs.getString(_eventsKey);
    
    if (eventsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(eventsJson);
    return decoded.map((e) => EventModel.fromJson(e)).toList();
  }

  Future<void> saveEvents(List<EventModel> events) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_eventsKey, encoded);
  }

  Future<void> addEvent(EventModel event) async {
    final events = await getEvents();
    events.add(event);
    await saveEvents(events);
  }

  Future<void> updateEvent(EventModel updatedEvent) async {
    final events = await getEvents();
    final index = events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      events[index] = updatedEvent;
      await saveEvents(events);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final events = await getEvents();
    events.removeWhere((e) => e.id == eventId);
    await saveEvents(events);
  }

  Future<List<EventModel>> getEventsForDay(DateTime day) async {
    final events = await getEvents();
    return events.where((e) => 
      e.date.year == day.year && 
      e.date.month == day.month && 
      e.date.day == day.day
    ).toList();
  }
}