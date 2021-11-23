import 'package:flutter/material.dart';
import 'package:dark_reminder/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  //DateTime _selectedDate = DateTime.now();

  //DateTime get selectedDate => _selectedDate;

  //void setDate(DateTime date) => _selectedDate = date;

  //List<Event> get eventsOfSelectedDate => _events;

  void addEvent(Event event) {
    _events.add(event);
  }

  CalendarController controller = CalendarController();
  String headerDateFormat = 'MMMM y';

  void changeView(CalendarView calendarView) {
    controller.view = calendarView;

    notifyListeners();
  }
}
