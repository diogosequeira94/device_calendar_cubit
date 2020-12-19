import 'package:device_calendar_sandbox/cubit/calendar_cubit.dart';
import 'package:device_calendar_sandbox/models/calendar_event_model.dart';
import 'package:device_calendar_sandbox/utils/calendar_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarEventFormPage extends StatelessWidget {
  final String selectedCalendarName;
  final String selectedCalendarId;

  CalendarEventFormPage({
    @required this.selectedCalendarName,
    @required this.selectedCalendarId
  });

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventDurationController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    final _addToCalenderCubit = BlocProvider.of<CalendarCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCalendarName),
      ),
      body: BlocListener(
        cubit: _addToCalenderCubit,
        listener: (context, state) {
          if (state is AddToCalendarFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          } else if (state is AddToCalendarSuccess) {
            Scaffold.of(context).showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500),
              content: Text('Success! Added to $selectedCalendarName'),
            ));
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(width: 160,
                    height: 160,
                    image: AssetImage(CalendarStrings.pathToCalendarImg)),
                const SizedBox(height: 18.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: eventNameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5.0),
                                ),
                                labelText: CalendarStrings.eventName),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: eventDescriptionController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5.0),
                                ),
                                labelText: CalendarStrings.eventDescription),
                            maxLines: 3,
                            maxLength: 250,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: eventDurationController,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                                ),
                                labelText: CalendarStrings.eventDuration),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          height: 40.0,
                          width: double.infinity,
                          child: BlocBuilder<CalendarCubit,
                              CalendarState>(builder: (context, state) {
                            if (state is AddToCalendarInProgress) {
                              return RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  onPressed: null,
                                  disabledColor: Theme.of(context).primaryColor,
                                  child: const SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ));
                            } else {
                              return RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    if (_areEventDetailsValid()) {
                                      _submitEvent(
                                          _addToCalenderCubit,
                                          eventNameController.text,
                                          eventDescriptionController.text,
                                      eventDurationController.text);
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500),
                                        content: Text(
                                            CalendarStrings.informationMissing),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    CalendarStrings.addToCalendar,
                                    style: TextStyle(color: Colors.white),
                                  ));
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _areEventDetailsValid() {
    return eventNameController.text.length != 0 &&
        eventDescriptionController.text.length != 0 && eventDurationController.text.length != 0;
  }

  void _submitEvent(CalendarCubit _addToCalendarCubit, String eventName,
      String eventDescription, String eventDuration) {

    var _calendarEvent = CalendarEventModel(
      eventTitle: eventName,
      eventDescription: eventDescription,
      eventDurationInHours: int.parse(eventDuration),
    );

    _addToCalendarCubit.addToCalendar(_calendarEvent, selectedCalendarId);
  }
}
