import 'package:bloc/bloc.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:equatable/equatable.dart';

import '../models/calendar_event_model.dart';
part 'add_to_calendar_state.dart';

class AddToCalendarCubit extends Cubit<AddToCalendarState> {
  final DeviceCalendarPlugin _deviceCalendarPlugin;

  AddToCalendarCubit(this._deviceCalendarPlugin)
      : super(AddToCalendarInitial());

  Future<List<Calendar>> loadCalendars() async {
    emit(AddToCalendarLoadCalendarsInProgress());
    // Retrieve user's calendars from mobile device
    // Request permissions first if they haven't been granted
    var _calendars;
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          emit(AddToCalendarLoadCalendarsFailure(
              'No permission to retrieve calendars!'));
          return List.empty();
        }
      }
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult?.data;
      if (_calendars.isEmpty || calendarsResult.errorMessages.length > 0) {
        emit(AddToCalendarLoadCalendarsFailure(
            'No calendars available were found, please try again.'));
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
    }
    emit(AddToCalendarLoadCalendarsSuccess('Success!'));
    return _calendars;
  }

  Future<void> addToCalendar(
      CalendarEventModel calendarEventModel, String selectedCalendarId) async {
    emit(AddToCalendarInProgress());
    //Added for visual purposes
    await Future.delayed(const Duration(seconds: 2));

    final _selectedCalendarId = selectedCalendarId;

    final eventTime = DateTime.now();
    final eventToCreate = Event(
      _selectedCalendarId,
      title: calendarEventModel.eventTitle,
      description: calendarEventModel.eventDescription,
      start: eventTime,
      end: eventTime.add(Duration(hours: calendarEventModel.eventDurationInHours)),
    );

    final createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

    if (createEventResult.isSuccess &&
        (createEventResult.data?.isNotEmpty ?? false)) {
      emit(AddToCalendarSuccess('Event was successfully created.'));
    } else {
      var errorMessage =
          'Could not create : ${createEventResult.errorMessages.toString()}';
      emit(AddToCalendarFailure(errorMessage));
    }
  }

  void calendarSelected() {
    emit(AddToCalendarCalendarSelected());
  }
}
