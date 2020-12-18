import 'package:flutter/material.dart';

class EventFormWidget extends StatelessWidget {

  final Function (String eventName, String eventDescription) getEventData;

  EventFormWidget(this.getEventData);

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: eventNameController,
              decoration: InputDecoration(
                  labelText: 'Event Name'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: eventDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Event description'
              ),
              maxLines: 5,
              maxLength: 250,
            ),
          ),
          const SizedBox(height: 8.0),
          FlatButton(onPressed: () {
            getEventData(eventNameController.text, eventDescriptionController.text);
          }, child: Text('Create Event')),
        ],
      ),
    );
  }
}
