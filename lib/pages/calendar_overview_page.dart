import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
import 'package:device_calendar_sandbox/pages/calendar_event_form_page.dart';
import 'package:device_calendar_sandbox/utils/calendar_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/add_to_calendar_cubit.dart';

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
          }
        },
        builder: (context, state) {
          if (state is AddToCalendarInitial) {
            return _buildInitialLayout();
          } else if (state is AddToCalendarLoadCalendarsInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AddToCalendarLoadCalendarsSuccess || state is AddToCalendarSuccess) {
            return _buildCalendarsListLayout(_calendars);
          } else {
            return Center(child: Text(state.toString()));
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
            'Available Device Calendars',
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
                return new ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(calendars[index].name),
                  subtitle: Text('Read Only? ${calendars[index].isReadOnly}'),
                  trailing: Text(calendars[index].id),
                  onTap: () {
                    if (calendars[index].isReadOnly) {
                      Scaffold.of(context).showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500),
                        content: Text('This calendar is read only!'),
                      ));
                    } else {
                      _selectedCalendarPressed(calendars[index].name, calendars[index].id);
                    }
                  },
                );
              }),
        ),
      ],
    ));
  }

  _selectedCalendarPressed(String selectedCalendarName, String selectedCalendarId){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
            value: BlocProvider.of<AddToCalendarCubit>(context),
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
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 32.0),
            Image(width: 200,
                height: 200,
                image: AssetImage('assets/images/calendar_icon.png')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      final calendarCubit = context.read<AddToCalendarCubit>();
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
