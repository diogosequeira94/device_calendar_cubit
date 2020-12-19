import 'package:bloc/bloc.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_sandbox/models/calendar_event_model.dart';
import 'package:device_calendar_sandbox/utils/calendar_strings.dart';
import 'package:equatable/equatable.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final DeviceCalendarPlugin _deviceCalendarPlugin;

  CalendarCubit(this._deviceCalendarPlugin)
      : super(CalendarInitial());

  Future<List<Calendar>> loadCalendars() async {
    emit(CalendarsLoadInProgress());
    //Added for visual purposes
    await Future.delayed(const Duration(seconds: 1));
    // Retrieve user's calendars from mobile device
    // Request permissions first if they haven't been granted
    var _calendars;
    try {
      var arePermissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (arePermissionsGranted.isSuccess && !arePermissionsGranted.data) {
        arePermissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!arePermissionsGranted.isSuccess || !arePermissionsGranted.data) {
          emit(CalendarsLoadFailure(
              CalendarStrings.noPermission));
          return List.empty();
        }
      }
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult?.data;
      if (_calendars.isEmpty || calendarsResult.errorMessages.length > 0) {
        emit(CalendarsLoadFailure(
            CalendarStrings.noCalendars));
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
    }
    emit(CalendarsLoadSuccess());
    return _calendars;
  }

  Future<void> addToCalendar(
      CalendarEventModel calendarEventModel, String selectedCalendarId) async {
    emit(AddToCalendarInProgress());
    //Added for visual purposes
    await Future.delayed(const Duration(seconds: 2));

    final eventTime = DateTime.now();
    final eventToCreate = Event(
      selectedCalendarId,
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
}
