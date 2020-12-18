import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/add_to_calendar_cubit.dart';
import '../models/calendar_event_model.dart';

class CalendarOverviewPage extends StatefulWidget {
  CalendarOverviewPage({Key key}) : super(key: key);

  @override
  _CalendarOverviewPageState createState() => _CalendarOverviewPageState();
}

class _CalendarOverviewPageState extends State<CalendarOverviewPage> {
  var _calendarEvent;
  var _calendars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event to Calendar Cubit Demo'),
      ),
      body: BlocConsumer<AddToCalendarCubit, AddToCalendarState>(
        listener: (context, state) {
          if (state is AddToCalendarLoadCalendarsInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AddToCalendarLoadCalendarsFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          } else if (state is AddToCalendarLoadCalendarsSuccess) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (context, state) {
          if (state is AddToCalendarInitial) {
            return _buildInitialLayout();
          }
          if (state is AddToCalendarInProgress) {
            return CircularProgressIndicator();
          } else {
            return _buildEventFormLayout();
          }
        },
      ),
      floatingActionButton:
          BlocConsumer<AddToCalendarCubit, AddToCalendarState>(
              listener: (context, state) {
        if (state is AddToCalendarFailure) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
        if (state is AddToCalendarSuccess) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      }, builder: (context, state) {
        if (state is AddToCalendarInitial) {
          return FloatingActionButton(
            onPressed: () {
              final calendarCubit = context.bloc<AddToCalendarCubit>();
              calendarCubit.addToCalendar(_calendarEvent, '2');
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        } else if (state is AddToCalendarInProgress) {
          return CircularProgressIndicator();
        } else if (state is AddToCalendarSuccess) {
          return FloatingActionButton(
            onPressed: () {
              final calendarCubit = context.bloc<AddToCalendarCubit>();
              calendarCubit.addToCalendar(_calendarEvent, '2');
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              final calendarCubit = context.bloc<AddToCalendarCubit>();
              calendarCubit.addToCalendar(_calendarEvent, '2');
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _submitEvent(String eventName, String eventDescription) {
    _calendarEvent = CalendarEventModel(
      eventTitle: eventName,
      eventDescription: eventDescription,
      eventDurationInHours: 3,
    );

    final calendarCubit = context.bloc<AddToCalendarCubit>();
    calendarCubit.addToCalendar(_calendarEvent, '0');
  }

  Widget _buildInitialLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Event Calendar App',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.deepOrange,
                    onPressed: () async {
                      final calendarCubit = context.bloc<AddToCalendarCubit>();
                      _calendars = await calendarCubit.loadCalendars();
                    },
                    child: Text(
                      'Show Calendars',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEventFormLayout() {
    final TextEditingController eventNameController = TextEditingController();
    final TextEditingController eventDescriptionController =
        TextEditingController();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Event Calendar App',
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
                            labelText: 'Event Name'),
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
                            labelText: 'Event description'),
                        maxLines: 3,
                        maxLength: 250,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                          color: Colors.deepOrange,
                          onPressed: () {
                            if (eventNameController.text != null &&
                                eventDescriptionController.text != null) {
                              _submitEvent(eventNameController.text,
                                  eventDescriptionController.text);
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Information missing'),
                              ));
                            }
                          },
                          child: Text(
                            'Create Event',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
