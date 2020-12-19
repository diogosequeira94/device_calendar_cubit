import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    final _addToCalenderCubit = BlocProvider.of<AddToCalendarCubit>(context);

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
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Success! Added to $selectedCalendarName'),
            ));
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  CalendarStrings.mainTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
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
                        const SizedBox(height: 8.0),
                        Container(
                          height: 40.0,
                          width: double.infinity,
                          child: BlocBuilder<AddToCalendarCubit,
                              AddToCalendarState>(builder: (context, state) {
                            if (state is AddToCalendarInProgress) {
                              return RaisedButton(
                                  color: Theme.of(context).primaryColor,
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
                                  onPressed: () {
                                    if (eventNameController.text != null &&
                                        eventDescriptionController.text !=
                                            null) {
                                      _submitEvent(
                                          _addToCalenderCubit,
                                          eventNameController.text,
                                          eventDescriptionController.text);
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
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

  void _submitEvent(AddToCalendarCubit _addToCalendarCubit, String eventName,
      String eventDescription) {
    var _calendarEvent = CalendarEventModel(
      eventTitle: eventName,
      eventDescription: eventDescription,
      eventDurationInHours: 3,
    );

    _addToCalendarCubit.addToCalendar(_calendarEvent, selectedCalendarId);
  }
}
