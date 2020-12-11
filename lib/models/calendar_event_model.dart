class CalendarEventModel {

  //Class to store MMA Event Data

  String eventName;
  DateTime eventDate;

  CalendarEventModel(this.eventName);

  void addDateOneFC(String date) {}

  String getPrefKey(){
  //Key used for the shared prefs to store the calendar event ID in case
  //the event needs to be updated
  //The first 4 digits of the event name are used since event titles
  //sometimes change, but the first 4 letters remain the same
  //The date is also used since the first 4 digits of name may be shared with
  //other events
  return eventName.substring(0,4) + eventDate.toIso8601String();
  }

  String getPrefBoolKey(){
  //Key used for bool preferences
  //Preferences must have different keys in shared_prefs library
  // or else conflicts occur
  return eventName.substring(0,5) + eventDate.toIso8601String();
  }
}

