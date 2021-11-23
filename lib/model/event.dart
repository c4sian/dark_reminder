final String tableEvents = 'events';

class EventFields {
  static final List<String> values = [
    // Add all fields
    id, title, fromDate, toDate, isAllDay, description
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String fromDate = 'fromDate';
  static final String toDate = 'toDate';
  static final String isAllDay = 'isAllDay';
  static final String description = 'description';
}

class Event {
  final int? id;
  final String title;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isAllDay;
  final String? description;

  const Event({
    this.id,
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.isAllDay,
    this.description,
  });

  Event copy({
    int? id,
    String? title,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isAllDay,
    String? description,
  }) =>
      Event(
        id: id ?? this.id,
        title: title ?? this.title,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        isAllDay: isAllDay ?? this.isAllDay,
        description: description ?? this.description,
      );

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        title: json[EventFields.title] as String,
        fromDate: DateTime.parse(json[EventFields.fromDate] as String),
        toDate: DateTime.parse(json[EventFields.toDate] as String),
        isAllDay: json[EventFields.isAllDay] == 1,
        description: json[EventFields.description] as String,
      );

  Map<String, Object?> toJson() => {
        EventFields.id: id,
        EventFields.title: title,
        EventFields.fromDate: fromDate.toIso8601String(),
        EventFields.toDate: toDate.toIso8601String(),
        EventFields.isAllDay: isAllDay ? 1 : 0,
        EventFields.description: description,
      };
}
