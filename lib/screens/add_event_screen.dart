import 'package:dark_reminder/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:dark_reminder/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:dark_reminder/model/event.dart';

class AddEditEventScreen extends StatefulWidget {
  final Event? event;
  final DateTime? selectedDate;

  const AddEditEventScreen({
    Key? key,
    this.event,
    this.selectedDate,
  }) : super(key: key);

  @override
  _AddEditEventScreenState createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _switchValue = false;
  DateTime now = DateTime.now();

  late DateTime fromDateTime;
  late DateTime toTime;
  late DateTime isDate;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      if (widget.selectedDate.isSameDate(now)) {
        fromDateTime = now.roundDown();
        toTime = (now.add(Duration(hours: 1))).roundDown();
        isDate = now;
      } else {
        fromDateTime = widget.selectedDate!.add(Duration(hours: 10));
        toTime = widget.selectedDate!.add(Duration(hours: 11));
        isDate = widget.selectedDate!;
      }
    } else {
      final event = widget.event!;

      _switchValue = event.isAllDay;
      _titleController.text = event.title;
      fromDateTime = event.fromDate;
      toTime = event.toDate;
      isDate = event.fromDate;
      _descriptionController.text = event.description!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
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
          title: Text('New Event'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: saveForm,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTitle(),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 24.0),
                    SizedBox(width: 12.0),
                    Text(
                      'All day',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Spacer(),
                    Switch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                      activeColor: kSecondColor,
                    ),
                  ],
                ),
                Divider(),
                _switchValue == false ? buildFromDateTime() : buildDate('From'),
                Divider(),
                _switchValue == false ? buildToTime() : buildDate('To'),
                Divider(),
                buildDescription()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPurpleColor, width: 1.30),
          ),
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.30),
          ),
          hintText: 'Title',
        ),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: _titleController,
      );

  Widget buildDescription() => TextField(
        textInputAction: TextInputAction.done,
        minLines: 1,
        maxLines: 2,
        decoration: InputDecoration(
          hintText: 'Description',
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.30),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPurpleColor, width: 1.30),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        controller: _descriptionController,
      );

  Widget buildFromDateTime() => GestureDetector(
        onTap: () {
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            onConfirm: (date) {
              if (date.isAfter(toTime)) {
                toTime = date.add(Duration(hours: 1));
              }
              setState(() {
                fromDateTime = date;
              });
            },
            currentTime: fromDateTime,
            minTime: DateTime.utc(2000, 1, 1, 0, 0),
            maxTime: DateTime.utc(2050, 12, 31, 23, 59),
            theme: datePickerTheme,
          );
        },
        child: Row(
          children: [
            SizedBox(width: 36.0),
            Text('From', style: TextStyle(fontSize: 20.0)),
            Spacer(),
            Text(Utils.toDateTime(fromDateTime)),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
      );

  Widget buildToTime() => GestureDetector(
        onTap: () {
          DatePicker.showTimePicker(
            context,
            showTitleActions: true,
            onConfirm: (date) {
              if (date.isBefore(fromDateTime)) {
                date = fromDateTime;
              }
              setState(() {
                toTime = date;
              });
            },
            currentTime: toTime,
            showSecondsColumn: false,
            theme: datePickerTheme,
          );
        },
        child: Row(
          children: [
            SizedBox(width: 36),
            Text('To', style: TextStyle(fontSize: 20.0)),
            Spacer(),
            Text(Utils.toTime(toTime)),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
      );

  Widget buildDate(String title) => GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.utc(2000, 1, 1, 0, 0),
            maxTime: DateTime.utc(2050, 12, 31, 23, 59),
            onConfirm: (date) {
              setState(() {
                isDate = date;
              });
            },
            currentTime: DateTime.now(),
            theme: datePickerTheme,
            locale: LocaleType.en,
          );
        },
        child: Row(
          children: [
            SizedBox(width: 36),
            Text(title, style: TextStyle(fontSize: 20.0)),
            Spacer(),
            Text(Utils.toDate(isDate)),
            Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.event != null;

      if (isUpdating) {
        await updateEvent();
      } else {
        await addEvent();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateEvent() async {
    final event = widget.event!.copy(
      title: _titleController.text,
      fromDate: _switchValue ? isDate : fromDateTime,
      toDate: _switchValue ? isDate : toTime,
      isAllDay: _switchValue,
      description: _descriptionController.text,
    );
    await EventsDatabase.instance.update(event);
  }

  Future addEvent() async {
    final event = Event(
      title: _titleController.text,
      fromDate: _switchValue ? isDate : fromDateTime,
      toDate: _switchValue ? isDate : toTime,
      isAllDay: _switchValue,
      description: _descriptionController.text,
    );
    await EventsDatabase.instance.create(event);
  }
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 5)}) {
    return DateTime.fromMillisecondsSinceEpoch(this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds);
  }
}

extension DateOnlyCompare on DateTime? {
  bool isSameDate(DateTime other) {
    return this!.year == other.year &&
        this!.month == other.month &&
        this!.day == other.day;
  }
}

// final event = Event(
//   title: _titleController.text,
//   description: _descriptionController.text,
//   from: fromDateTime,
//   to: toTime,
//   isAllDay: _switchValue,
// );
//
// final isEdited = widget.event != null;
// final provider = Provider.of<EventProvider>(context, listen: false);
//
// if (isEdited) {
// provider.editEvent(event, widget.event!);
// } else {
// provider.addEvent(event);
// }
// Navigator.pop(context);
