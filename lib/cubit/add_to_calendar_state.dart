part of 'add_to_calendar_cubit.dart';

abstract class AddToCalendarState extends Equatable {
  const AddToCalendarState();
}

class AddToCalendarInitial extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarInProgress extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarSuccess extends AddToCalendarState {
  @override
  List<Object> get props => [];
}

class AddToCalendarFailure extends AddToCalendarState {
  final String message;
  const AddToCalendarFailure(this.message);

  @override
  List<Object> get props => [message];
}
