import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CalendarEventModel extends Equatable {
  final String eventTitle;
  final String eventDescription;
  final int eventDurationInHours;

  const CalendarEventModel({
    @required this.eventTitle,
    @required this.eventDescription,
    @required this.eventDurationInHours
  });

  @override
  List<Object> get props => [
    eventTitle,
    eventDescription,
    eventDurationInHours
  ];
}
