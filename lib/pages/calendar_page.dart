import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Calendar App',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: BlocConsumer<AddToCalendarCubit, AddToCalendarState>(
        listener: (context, state) {
          if(state is AddToCalendarFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message),
              )
            );
          }
          if(state is AddToCalendarSuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Added with Success'),
              )
            );
          }
        },
        builder: (context, state) {
          if(state is AddToCalendarInitial) {
            return FloatingActionButton(
              onPressed: () {
                final calendarCubit = context.bloc<AddToCalendarCubit>();
                calendarCubit.addToCalendar();
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
                calendarCubit.addToCalendar();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          } else {
            return FloatingActionButton(
              onPressed: () {
                final calendarCubit = context.bloc<AddToCalendarCubit>();
                calendarCubit.addToCalendar();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          }
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}