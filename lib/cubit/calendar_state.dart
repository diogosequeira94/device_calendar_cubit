part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarsLoadInProgress extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarsLoadSuccess extends CalendarState {
  const CalendarsLoadSuccess();

  @override
  List<Object> get props => [];
}

class CalendarsLoadFailure extends CalendarState {
  final String message;
  const CalendarsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCalendarInProgress extends CalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarSuccess extends CalendarState {
  final String message;
  const AddToCalendarSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCalendarFailure extends CalendarState {
  final String message;
  const AddToCalendarFailure(this.message);

  @override
  List<Object> get props => [message];
}
