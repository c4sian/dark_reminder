import 'package:dark_reminder/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).fromDate;

  @override
  DateTime getEndTime(int index) => getEvent(index).toDate;

  @override
  String getSubject(int index) => getEvent(index).title;

  // @override
  // Color getColor(int index) => getEvent(index).backgroundColor;

  @override
  String? getNotes(int index) => getEvent(index).description;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}