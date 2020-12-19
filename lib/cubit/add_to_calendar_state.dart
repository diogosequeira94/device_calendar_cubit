part of 'add_to_calendar_cubit.dart';

abstract class AddToCalendarState extends Equatable {
  const AddToCalendarState();
}

class AddToCalendarInitial extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarLoadCalendarsInProgress extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarLoadCalendarsSuccess extends AddToCalendarState {
  final String message;
  const AddToCalendarLoadCalendarsSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCalendarLoadCalendarsFailure extends AddToCalendarState {
  final String message;
  const AddToCalendarLoadCalendarsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCalendarInProgress extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarSuccess extends AddToCalendarState {
  final String message;
  const AddToCalendarSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddToCalendarFailure extends AddToCalendarState {
  final String message;
  const AddToCalendarFailure(this.message);

  @override
  List<Object> get props => [message];
}
