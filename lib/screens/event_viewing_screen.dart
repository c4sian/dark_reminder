import 'package:dark_reminder/database/database_helper.dart';
import 'package:dark_reminder/screens/add_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:dark_reminder/model/event.dart';
import 'package:dark_reminder/utils.dart';

class EventViewingScreen extends StatefulWidget {
  final int eventId;

  const EventViewingScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<EventViewingScreen> createState() => _EventViewingScreenState();
}

class _EventViewingScreenState extends State<EventViewingScreen> {
  late Event event;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshEvent();
  }

  Future refreshEvent() async {
    setState(() => isLoading = true);

    this.event = await EventsDatabase.instance.readEvent(widget.eventId);

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
          title: Text('View Event'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          leading: CloseButton(),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(fontSize: 28.0),
                    ),
                    Divider(
                      color: kPurpleColor,
                      indent: 0,
                      thickness: 3,
                      height: 20,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 32.0),
                        SizedBox(width: 12.0),
                        event.isAllDay ? buildDate() : buildDateTime(),
                      ],
                    ),
                    SizedBox(height: 26.0),
                    event.description != '' ? buildDescription() : Container(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildDescription() => Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: kPurpleColor, width: 1.30),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          event.description!,
          style: TextStyle(fontSize: 18.0),
        ),
      );

  Widget buildDate() => Text(
        Utils.toDate(event.fromDate),
        style: TextStyle(fontSize: 18.0),
      );

  Widget buildDateTime() => Column(
        children: [
          Text(
            '${Utils.toDate(event.fromDate)},',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '${Utils.toTime(event.fromDate)} - ${Utils.toTime(event.toDate)}',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );

  Widget editButton() => IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditEventScreen(event: event),
            ),
          );
          refreshEvent();
        },
      );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await EventsDatabase.instance.delete(widget.eventId);

          Navigator.of(context).pop();
        },
      );
}
