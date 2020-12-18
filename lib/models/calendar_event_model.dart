import 'package:meta/meta.dart';

class CalendarEventModel {
  final String eventTitle;
  final String eventDescription;
  final int eventDurationInHours;

  const CalendarEventModel({
    @required this.eventTitle,
    @required this.eventDescription,
    @required this.eventDurationInHours}
  );
}
