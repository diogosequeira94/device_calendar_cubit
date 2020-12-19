import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_sandbox/cubit/calendar_cubit.dart';
import 'package:device_calendar_sandbox/pages/calendar_event_form_page.dart';
import 'package:device_calendar_sandbox/utils/calendar_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarOverviewPage extends StatefulWidget {
  CalendarOverviewPage({Key key}) : super(key: key);

  @override
  _CalendarOverviewPageState createState() => _CalendarOverviewPageState();
}

class _CalendarOverviewPageState extends State<CalendarOverviewPage> {
  var _calendars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CalendarStrings.appTitle),
      ),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state is CalendarsLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CalendarsLoadFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (context, state) {
          if (state is CalendarInitial) {
            return _buildInitialLayout();
          } else if (state is CalendarsLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CalendarsLoadSuccess || state is AddToCalendarSuccess) {
            return _buildCalendarsListLayout(_calendars);
          } else if (state is CalendarsLoadFailure){
            return _buildInitialLayout();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
          child: Text(
            'Available Calendars',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: double.maxFinite,
          child: ListView.builder(
              itemCount: calendars.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Image(
                      height: 40.0,
                        width: 40.0,
                        image: AssetImage(CalendarStrings.pathToCalendarImg)),
                    title: Text(calendars[index].name),
                    subtitle: Text('Is Read Only? ${calendars[index].isReadOnly ? 'Yes' : 'No'}'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      if (calendars[index].isReadOnly) {
                        Scaffold.of(context).showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500),
                          content: Text('This calendar is read only!'),
                        ));
                      } else {
                        _selectedCalendarPressed(calendars[index].name, calendars[index].id);
                      }
                    },
                  ),
                );
              }),
        ),
      ],
    ));
  }

  _selectedCalendarPressed(String selectedCalendarName, String selectedCalendarId){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
            value: BlocProvider.of<CalendarCubit>(context),
            child: CalendarEventFormPage(
                selectedCalendarName: selectedCalendarName,
                selectedCalendarId: selectedCalendarId))));
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
                fontSize: 30.0,
              ),
            ),
            const SizedBox(height: 32.0),
            Image(width: 200,
                height: 200,
                image: AssetImage(CalendarStrings.pathToCalendarImg)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () async {
                      final calendarCubit = context.read<CalendarCubit>();
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
}
