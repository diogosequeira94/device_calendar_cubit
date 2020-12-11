import 'package:bloc/bloc.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:equatable/equatable.dart';
part 'add_to_calendar_state.dart';

class AddToCalendarCubit extends Cubit<AddToCalendarState> {
  final DeviceCalendarPlugin _deviceCalendarPlugin;

  AddToCalendarCubit(this._deviceCalendarPlugin)
      : super(AddToCalendarInitial());

  Future<void> addToCalendar() async {
    emit(AddToCalendarInProgress());

    final _calendars = await _retrieveCalendars();

    if (_calendars.length > 0) {
      var _selectedCalendar = _calendars[0];
      print(
          '######### THIS IS SELECTED CALENDAR ${_selectedCalendar.name} ############');

      final eventTime = DateTime.now();
      final eventToCreate = Event(_selectedCalendar?.id);
      eventToCreate?.title = 'Test 1';
      eventToCreate?.start = eventTime;
      eventToCreate?.description = 'Super Test Description';
      eventToCreate?.end = eventTime.add(new Duration(hours: 3));

      final createEventResult =
      await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

      if (createEventResult.isSuccess &&
          (createEventResult.data?.isNotEmpty ?? false)) {
        emit(AddToCalendarSuccess());
        print('CREATED SUCCESSFULLY!!!');
      } else {
        var errorMessage = 'Could not create : ${createEventResult.errorMessages.toString()}';
        emit(AddToCalendarFailure(errorMessage));
      }
    } else {
      print('######### NO CALENDARS AVAILABLE ############');
    }
  }

  Future<List<Calendar>> _retrieveCalendars() async {
    // Retrieve user's calendars from mobile device
    // Request permissions first if they haven't been granted
    var _calendars;
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if(permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if(!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return List.empty();
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
        _calendars = calendarsResult?.data;
        print('################# $_calendars ###################');
        for(var calendars in _calendars) {
          print('######## IS DEFAULT? ${calendars.isDefault} + ${calendars.id} + ${calendars.name} + ${calendars.isReadOnly} ##########');
        }
        return _calendars;
    } catch (e) {
      print(e.toString());
    }
    return _calendars;
  }
}

