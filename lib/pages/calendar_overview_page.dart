import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
import 'package:device_calendar_sandbox/utils/calendar_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/add_to_calendar_cubit.dart';
import '../cubit/add_to_calendar_cubit.dart';
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
        title: Text(CalendarStrings.appTitle),
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
          } else if (state is AddToCalendarFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          } else if (state is AddToCalendarSuccess) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          } else if(state is AddToCalendarCalendarSelected){
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Calendar Was Selected!'),
            ));
          }
        },
        builder: (context, state) {
          if (state is AddToCalendarInitial) {
            return _buildInitialLayout();
          } else if (state is AddToCalendarLoadCalendarsSuccess) {
            return _buildCalendarsListLayout(_calendars);
          } else if(state is AddToCalendarCalendarSelected) {
            return _buildEventFormLayout();
          } else {
            return _buildInitialLayout();
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
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

  Widget _buildCalendarsListLayout(List<Calendar> calendars) {
    return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Available Device Calendars', style: TextStyle(
                fontSize: 18.0,
              ),),
            ),
            Container(
              height: double.maxFinite,
              child: ListView.builder(
                  itemCount: calendars.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(calendars[index].name),
                      subtitle: Text('Read Only? ${calendars[index].isReadOnly}'),
                      trailing: Text(calendars[index].id),
                      onTap: () {
                        if(calendars[index].isReadOnly){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('This calendar is read only!'),
                          ));
                        } else {
                          final calendarCubit = context.bloc<AddToCalendarCubit>();
                          calendarCubit.calendarSelected();
                        }
                      },
                    );
                  }),
            ),
          ],
        ));
  }

  Widget _buildInitialLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              CalendarStrings.mainTitle,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      final calendarCubit = context.bloc<AddToCalendarCubit>();
                      _calendars = await calendarCubit.loadCalendars();
                    },
                    child: Text(
                      CalendarStrings.showCalendarsBtn,
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
                      child:
                          BlocBuilder<AddToCalendarCubit, AddToCalendarState>(
                              builder: (context, state) {
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
                                    eventDescriptionController.text != null) {
                                  _submitEvent(eventNameController.text,
                                      eventDescriptionController.text);
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
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
    );
  }
}
