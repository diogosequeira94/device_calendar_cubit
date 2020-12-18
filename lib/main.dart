import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_sandbox/cubit/add_to_calendar_cubit.dart';
import 'package:device_calendar_sandbox/pages/calendar_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
          create: (context) => AddToCalendarCubit(DeviceCalendarPlugin()),
          child: CalendarOverviewPage()),
    );
  }
}
