import 'package:dark_reminder/database/database_helper.dart';
import 'package:dark_reminder/utils.dart';
import 'package:flutter/material.dart';
import 'package:dark_reminder/model/event.dart';
import 'package:dark_reminder/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:dark_reminder/screens/event_viewing_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:dark_reminder/model/event_data_source.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dark_reminder/screens/add_event_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Event> events = Provider.of<EventProvider>(context).events;
  String headerDateFormat = 'MMMM y';
  int _index = 1;
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    refreshEvents();
  }

  @override
  void dispose() {
    EventsDatabase.instance.close();

    super.dispose();
  }

  Future refreshEvents() async {
    setState(() => isLoading = true);

    this.events = await EventsDatabase.instance.readAllEvents();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            kBlackColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dark Reminder'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        extendBody: true,
        bottomNavigationBar: buildFloatingBar(),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : events.isEmpty
                  ? buildCalendar()
                  : buildEvents(),
        ),
      ),
    );
  }

  Widget buildCalendar() => SfCalendar(
        firstDayOfWeek: 1,
        allowViewNavigation: false,
        view: CalendarView.month,
        controller: Provider.of<EventProvider>(context).controller,
        initialSelectedDate: selectedDate,
        cellBorderColor: Colors.transparent,
        showNavigationArrow: true,
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
        ),
        monthViewSettings: MonthViewSettings(
          dayFormat: 'EEE',
          showAgenda: true,
          numberOfWeeksInView: 6,
          agendaStyle: AgendaStyle(
            appointmentTextStyle: TextStyle(fontSize: 15.0),
            dayTextStyle: TextStyle(fontSize: 13.0),
          ),
        ),
        headerDateFormat: headerDateFormat,
        dataSource: EventDataSource(events),
        todayHighlightColor: kPurpleColor,
        selectionDecoration: BoxDecoration(
          border: Border.all(
            color: kPurpleColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        appointmentTimeTextFormat: 'HH:mm',
        onTap: (details) async {
          if (details.targetElement == CalendarElement.calendarCell) {
            if (details.date != DateTime.now()) {
              selectedDate = details.date!;
            }
          }
          if (details.targetElement == CalendarElement.appointment) {
            if (details.appointments == null) return;

            final event = details.appointments!.first;

            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventViewingScreen(eventId: event.id!)));
            refreshEvents();
          }
        },
      );

  Widget buildEvents() => ListView.builder(
        itemCount: events.length,
        itemExtent: 550,
        itemBuilder: (context, index) {
          final event = events[index];
          Provider.of<EventProvider>(context, listen: false).addEvent(event);

          return buildCalendar();
        },
      );

  Widget buildFloatingBar() => FloatingNavbar(
        backgroundColor: kDarkPurpleColor,
        selectedBackgroundColor: Colors.transparent,
        unselectedItemColor: Colors.white,
        selectedItemColor: kBlackColor,
        padding: EdgeInsets.zero,
        borderRadius: 10.0,
        iconSize: 20.0,
        margin: EdgeInsets.zero,
        width: double.infinity,
        onTap: (value) {
          setState(() {
            _index = value;
          });
          switch (value) {
            case 1:
              {
                Provider.of<EventProvider>(context, listen: false)
                    .changeView(CalendarView.month);
              }
              break;
            case 2:
              {
                Provider.of<EventProvider>(context, listen: false)
                    .changeView(CalendarView.week);
              }
              break;
            case 3:
              {
                Provider.of<EventProvider>(context, listen: false)
                    .changeView(CalendarView.day);
              }
              break;
          }
        },
        currentIndex: _index,
        items: [
          FloatingNavbarItem(
            customWidget: IconButton(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(maxHeight: 20),
              icon: Icon(
                Icons.add,
                size: 22.0,
                color: Colors.black,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddEditEventScreen(selectedDate: selectedDate);
                  }),
                );
                refreshEvents();
              },
            ),
            title: 'New Event',
          ),
          FloatingNavbarItem(
              icon: FontAwesomeIcons.calendarAlt, title: 'Month'),
          FloatingNavbarItem(
              icon: FontAwesomeIcons.calendarWeek, title: 'Week'),
          FloatingNavbarItem(icon: FontAwesomeIcons.calendarDay, title: 'Day'),
        ],
      );
}
